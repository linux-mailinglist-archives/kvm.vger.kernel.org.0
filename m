Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F6D509B75
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 11:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiDUJIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 05:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387292AbiDUJHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 05:07:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141BE58;
        Thu, 21 Apr 2022 02:04:56 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L6TWKC030106;
        Thu, 21 Apr 2022 09:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ssEM0Bntem7STklppLTrWeCJtoDio67aLNzOBra8u2w=;
 b=Rl7+d1mlnI1u4qSHNokNt4E/uXwnWIMaI81a2WAc/pf6yrNYkiRdHQGKe6w5ehxcibtV
 /EllXb+0EOxSLK0WfieRKAU0lScy2NaSD1EwOzk8efQMJrlL4zBIZMwRWqQk1vetCKOE
 ZEGaHuEXkBrogWlGcdxVHDzaD1FfWQvyjzdWvRF+uzWvX78wRy2Dp923C/6ten3QH/Mw
 Koxin9YwJ8uHSe1DLsAVMyCHUcxZlJ4RfBbcJbLzEEP2LG1HXxvIyBhFwqoLmPTB2VNw
 fPgYgx9MDpjIbnimQNem2y34S1eNKxZD6jS0L0ZpbrcvojM2iO8JoEkonl/owfTNljdO +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4bku7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:56 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8oTsC003037;
        Thu, 21 Apr 2022 09:04:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4bktf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L93E3l015393;
        Thu, 21 Apr 2022 09:04:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne97juc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:04:53 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L94oXg45547920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 09:04:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA165204F;
        Thu, 21 Apr 2022 09:04:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CFCBF52052;
        Thu, 21 Apr 2022 09:04:49 +0000 (GMT)
Date:   Thu, 21 Apr 2022 11:04:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Misc maintenance fixes 2022-04
Message-ID: <20220421110448.66af219d@p-imbrenda>
In-Reply-To: <20220421085021.1651688-1-nrb@linux.ibm.com>
References: <20220421085021.1651688-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BsWm7xXxH7cFSzPrd2RhqMhAGCTFt-hb
X-Proofpoint-GUID: LXeBXZ3w13_KWgVr7eMqaK1EOm-2JG12
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Apr 2022 10:50:18 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Changelog from v1:
> ----
> * tprot: Change system include to lib include in commit message
> 
> Misc small fixes, which I previously sent as:
> - [kvm-unit-tests PATCH v1 1/3] s390x: epsw: fix report_pop_prefix() when
>   running under non-QEMU
> - [kvm-unit-tests PATCH v1 2/3] s390x: tprot: use system include for mmu.h
> - [kvm-unit-tests PATCH v1 3/3] s390x: smp: make stop stopped cpu look the same
>   as the running case
> 
> I broke the threading when I sent the patches, so Janosch asked me to
> resend this as a new series.

thanks, queued

> 
> Nico Boehr (3):
>   s390x: epsw: fix report_pop_prefix() when running under non-QEMU
>   s390x: tprot: use lib include for mmu.h
>   s390x: smp: make stop stopped cpu look the same as the running case
> 
>  s390x/epsw.c  | 4 ++--
>  s390x/smp.c   | 5 +++--
>  s390x/tprot.c | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 

