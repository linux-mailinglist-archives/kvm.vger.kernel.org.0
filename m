Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14994FF927
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiDMOoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 10:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiDMOnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 10:43:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD1E50063;
        Wed, 13 Apr 2022 07:41:32 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DDg1EJ026187;
        Wed, 13 Apr 2022 14:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=JI0QhSUDOU9ItxwJFtntqhZanXjqRH5K2V34DsoKGT0=;
 b=ZmDidAgKi/wvmBPhuxQpMK2EE4z/+FIQ2C8yYxkjtxRniVD8PRkvv3wtJf1NVlSGBxAw
 ylOMc0pSZR9lJRT0Gg7TvJht76U5cIadgpq5+4iXKAh7GL1bNQv6laeeF0ncWrjMOq99
 x9GAv0lMq/SLM1UFHVPo3b9NmbqExzEWcxphH7utHtUmbN88RiGmuwS4Rp0q383fEaR9
 /bxiM/5zIpHtmemXHzMnODYAC+czvUe5YMLIj+6pbhXMiPvs6nthSVVkGuGQwONNPrxe
 VKzi8eQItK7VCeIxZJVMN1g2DcV1li4R8JKCtBdOmszOn0ai1Ots3wHDnZSgLMy0Er4Z Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdymf9f6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:41:31 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23DEDWmI020987;
        Wed, 13 Apr 2022 14:41:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdymf9f62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:41:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DEYIZQ030817;
        Wed, 13 Apr 2022 14:41:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8nmxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:41:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DEfPUx39125264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 14:41:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 844E6A4060;
        Wed, 13 Apr 2022 14:41:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43844A4054;
        Wed, 13 Apr 2022 14:41:25 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.44.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 14:41:25 +0000 (GMT)
Message-ID: <bc1f4b507234702e662a4fa19c6875d95d5591b1.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add support for SCLP
 console read
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Wed, 13 Apr 2022 16:41:25 +0200
In-Reply-To: <3cac38d6-41f1-1c5e-1af1-c19f3f68aab2@redhat.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
         <20220411100750.2868587-2-nrb@linux.ibm.com>
         <3cac38d6-41f1-1c5e-1af1-c19f3f68aab2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vPePS4UU9FNTUWYMU9XHgrWxiC0H_baa
X-Proofpoint-GUID: nI8T3WYeFw5nLdGRAS46eDRbMuvMIfVN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=880 mlxscore=0 clxscore=1015
 adultscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 10:02 +0200, Thomas Huth wrote:
> On 11/04/2022 12.07, Nico Boehr wrote:
> > Add a basic implementation for reading from the SCLP ACII console.
> > The goal of
> 
> s/ACII/ASCII/

Thanks, fixed.

[...]
> > diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
> > index fa36a6a42381..8e22660bf25d 100644
[...]
> > +static int console_refill_read_buffer(void)
> > +{
> > +       const int MAX_EVENT_BUFFER_LEN = SCCB_SIZE -
> > offsetof(ReadEventDataAsciiConsole, ebh);
> > +       ReadEventDataAsciiConsole *sccb = (void *)_sccb;
> > +       const int EVENT_BUFFER_ASCII_RECV_HEADER_LEN = sizeof(sccb-
> > >ebh) + sizeof(sccb->type);
> > +       int ret = -1;
> > +
> > +       sclp_console_enable_read();
> > +
> > +       sclp_mark_busy();
> > +       memset(sccb, 0, 4096);
> > +       sccb->h.length = PAGE_SIZE;
> > +       sccb->h.function_code = SCLP_UNCONDITIONAL_READ;
> > +       sccb->h.control_mask[2] = 0x80;
> 
> Add at least a comment about what the 0x80 means, please?

Oh yes, thanks. We already have a define for it which I will use
instead of the comment: SCLP_CM2_VARIABLE_LENGTH_RESPONSE


[...]
> > +
> > +       read_buf_end = sccb->ebh.length -
> > EVENT_BUFFER_ASCII_RECV_HEADER_LEN;
> > +
> > +       assert(read_buf_end <= sizeof(read_buf));
> > +       memcpy(read_buf, sccb->data, read_buf_end);
> > +
> > +       read_index = 0;
> 
> Set "ret = 0" here?

Oooops, excellent catch. Thanks, fixed.

