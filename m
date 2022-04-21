Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63EC509F32
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382807AbiDUMCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 08:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382755AbiDUMCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 08:02:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EC2ED71;
        Thu, 21 Apr 2022 04:59:29 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LBuP3f004924;
        Thu, 21 Apr 2022 11:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tpmmp9WK1HsAkLROYtxLyS3Z8zVE1BCFvUUg+wcoj1Q=;
 b=YY4pNfvzB7HLvVbb3CoU+Q+6RB5up0A6LWUXoZeXJVFsJJ/mhrPQpDMDgppjhP9ApxHn
 7xNdm4cEc/kwq4KqfVsRwHYMYvMCKdEBR7n0MSpPfX4cHMod9WVkP54cRI/AxzDjT534
 WrWYsVEBWE9XU+XDprhSsT4YgWUq0NnbQp7ZKyCw8X+2mlbqQf8JvM164fuuVRJBQONg
 U2yvFgNFPlaqrUymegC3pQCM4dVj42wlUj7WQ2oxp9RZ6F2Z29XOblOuAeflfeW9tlxx
 J9BO0gTBT6EXgoUGzD0qoxroUHDGF9wxtjo4H1avif/kjo/oqhwX9X8Ei9xVn1P8hn7u cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfrj60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:28 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LBE88n023563;
        Thu, 21 Apr 2022 11:59:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfrj5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LBqIdx016140;
        Thu, 21 Apr 2022 11:59:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8qsxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LBxN7N48300308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 11:59:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F29E2A4053;
        Thu, 21 Apr 2022 11:59:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F67CA4040;
        Thu, 21 Apr 2022 11:59:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 11:59:22 +0000 (GMT)
Date:   Thu, 21 Apr 2022 13:59:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 00/11] s390x: Cleanup and maintenance
 4
Message-ID: <20220421135920.426687fc@p-imbrenda>
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P6X6lf8nbHN0qS--MYN5-mGkchRyEQMh
X-Proofpoint-GUID: siBaPhmj4r_kvlVTmylqcyGszx7SKjzY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Apr 2022 10:11:19 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> A few small cleanups and two patches that I forgot to upstream which
> have now been rebased onto the machine.h library functions.

thanks, queued

> 
> v3:
> 	* Added review tags
> 	* Added uv-host and diag308 fix
> 	* Diag308 subcode 2 patch, moved the prefix push and pop outside of the if
> 
> v2:
> 	* Added host_is_qemu() function
> 	* Fixed qemu checks
> 
> Janosch Frank (11):
>   lib: s390x: hardware: Add host_is_qemu() function
>   s390x: css: Skip if we're not run by qemu
>   s390x: diag308: Only test subcode 2 under QEMU
>   s390x: pfmf: Initialize pfmf_r1 union on declaration
>   s390x: snippets: asm: Add license and copyright headers
>   s390x: pv-diags: Cleanup includes
>   s390x: css: Cleanup includes
>   s390x: iep: Cleanup includes
>   s390x: mvpg: Cleanup includes
>   s390x: uv-host: Fix pgm tests
>   s390x: Restore registers in diag308_load_reset() error path
> 
>  lib/s390x/hardware.h                       |  5 +++
>  s390x/cpu.S                                |  1 +
>  s390x/css.c                                | 18 ++++++----
>  s390x/diag308.c                            | 18 +++++++++-
>  s390x/iep.c                                |  3 +-
>  s390x/mvpg.c                               |  3 --
>  s390x/pfmf.c                               | 39 +++++++++++-----------
>  s390x/pv-diags.c                           | 17 ++--------
>  s390x/snippets/asm/snippet-pv-diag-288.S   |  9 +++++
>  s390x/snippets/asm/snippet-pv-diag-500.S   |  9 +++++
>  s390x/snippets/asm/snippet-pv-diag-yield.S |  9 +++++
>  s390x/uv-host.c                            |  2 +-
>  12 files changed, 85 insertions(+), 48 deletions(-)
> 

