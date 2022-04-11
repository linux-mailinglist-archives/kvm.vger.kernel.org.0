Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0CE4FBCFA
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiDKNZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346454AbiDKNZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:25:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D59B3B572;
        Mon, 11 Apr 2022 06:23:24 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BCBtlk018716;
        Mon, 11 Apr 2022 13:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=hYcOrK8gXCx5Q8pbp0jxcei42fqIUFDAN3Grr9Begeo=;
 b=gDKmRgqnwJ1jHBqsrgIXzzUqhgAlJmx7qHSfKOL+Umy08RWtfdZg2+YJoF4pZi0azOHd
 HcF+qNHrpfi/penZ67Se0hMDkNUsvYwC1axxqbnFUFEt/x7R7CIb6yd3YDeehwjNNy4K
 kou5ZiHqYdEFqvadw6/aBHs9c/MaKbkmCAmHeo03Gv447ueugLaH93LuDLEScjoLCrBJ
 ARK4dAO4F7AfwPjW3mheduDz7zLwE86RE3FplrwbNfjoM4QcwBxg5uDwc5srFITACkWJ
 UnszZ4U1vym0eFNKZBa7EP9qLNeLRHx2pfM5kmN1Y4FZZjR/PMDFmzD++JJkyYyhb4w0 pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcm4cshkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:23:24 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BCD3jk021337;
        Mon, 11 Apr 2022 13:23:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcm4cshjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:23:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrW2S023817;
        Mon, 11 Apr 2022 13:23:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8jhah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:23:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BDNI1F27721998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:23:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8BCEA4054;
        Mon, 11 Apr 2022 13:23:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98EE6A405C;
        Mon, 11 Apr 2022 13:23:17 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.68.171])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 13:23:17 +0000 (GMT)
Message-ID: <243cc4903700b39072a20636f2433d43320fe4c2.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: add test for SIGP
 STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Mon, 11 Apr 2022 15:23:17 +0200
In-Reply-To: <20220406153107.0b071dcc@p-imbrenda>
References: <20220401123321.1714489-1-nrb@linux.ibm.com>
         <20220401123321.1714489-3-nrb@linux.ibm.com>
         <20220406153107.0b071dcc@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Iwl2aDorT6T9OtFffhvWzLjSVBuem6ZG
X-Proofpoint-ORIG-GUID: Mcv4n4-WikHcpu7Lql9LtqdnVg_0Kt63
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-06 at 15:31 +0200, Claudio Imbrenda wrote:
> > diff --git a/s390x/adtl-status.c b/s390x/adtl-status.c
> > new file mode 100644
> > index 000000000000..c3ecdbc35a9d
> > 
[...]
> > +static void restart_write_vector(void)
> > +{
> > +       uint8_t *vec_reg;
> > +       /* vlm handles at most 16 registers at a time */
> > +       uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
> > +       uint64_t cr0, cr0_mask = ~(1ULL << CTL0_VECTOR);
> 
> cr0_mask can be const, and you can use ~BIT_ULL(CTL0_VECTOR)

I don't think so, since ng in the inline ASM will store its result
there.

BIT_ULL is much better, thanks. I tend to forget about that.

> 
> > +       int one = 1;
> 
> one can also be const, although I wonder if this can just become an
> constant in the asm statement

Yes, right, thanks. Should work with mvhi.

