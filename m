Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6503660715B
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJUHqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 03:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJUHqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 03:46:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C786208809
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:46:37 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L7bgYh028531
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 07:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=swUrOMw4u3T9T0cSKklBAvF1oaRjdvGBblil3dir13U=;
 b=Tw1f3nrlroIwiog5keBr8CeLfgAbxmBhFQSe8vYnZO4twA3URwvWCAtjgAE9e2ifo+5N
 sTILF03NB4N+GQ7+JLWZs39nn/ir6DH8Fm4N1vO9Dlu6GlUo3+sldS6H74p0cyEZaTBO
 E258nrEi1Znb0FhGirXg5om6dm+x4Sor4oaRRoQTPb64bObbMAhy/antEKtJGixtd6Bj
 VA2L4AzLn2WWu/RQJHz1wQMSv+TWGp6ma8ChN67QckBU8pvrvxi9k0Lk0sIlyu90NpuN
 52FmTTtUEHN4RZu4HXhSKd65GkPhFG2gW9Zb3xVB5giFyUV+Y71TkjoIZPCZEx0TAt21 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbq6tr910-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 07:46:36 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L7cOM5000682
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 07:46:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbq6tr8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 07:46:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L7ZSLF017255;
        Fri, 21 Oct 2022 07:46:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg9a3pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 07:46:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L7kUqu4915844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 07:46:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0243A405F;
        Fri, 21 Oct 2022 07:46:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71A4EA405B;
        Fri, 21 Oct 2022 07:46:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 07:46:30 +0000 (GMT)
Date:   Fri, 21 Oct 2022 09:46:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] s390x: PV fixups
Message-ID: <20221021094628.79239c86@p-imbrenda>
In-Reply-To: <20221021063902.10878-1-frankja@linux.ibm.com>
References: <20221021063902.10878-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IvjC9rFnnVnp-EfmzNp3kMf0bNI1AR2c
X-Proofpoint-ORIG-GUID: ptB6jX5n_chkd50oY_wzjX-F6ZQiVCF0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=969
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Oct 2022 06:38:56 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> A small set of patches that clean up the PV snippet handling.
> 
> v3:
> 	* Dropped asm snippet linker script patch for now

shame, I really liked that patch (modulo the nits)

> 	* Replaced memalign_pages_flags() with memalign_pages()
> 	* PV ASCEs will now recieve DT and TL fields from the main test ASCE
> 
> v2:
> 	* Macro uses 64bit PSW mask
> 	* SBLK reset on PV destroy and uv_init() early return have been split off
> 
> 
> Janosch Frank (6):
>   s390x: snippets: asm: Add a macro to write an exception PSW
>   s390x: MAKEFILE: Use $< instead of pathsubst
>   lib: s390x: sie: Improve validity handling and make it vm specific
>   lib: s390x: Use a new asce for each PV guest
>   lib: s390x: Enable reusability of VMs that were in PV mode
>   lib: s390x: sie: Properly populate SCA
> 
>  lib/s390x/asm-offsets.c                  |  2 ++
>  lib/s390x/sie.c                          | 37 +++++++++++++-------
>  lib/s390x/sie.h                          | 43 ++++++++++++++++++++++--
>  lib/s390x/uv.c                           | 35 +++++++++++++++++--
>  lib/s390x/uv.h                           |  5 ++-
>  s390x/Makefile                           |  2 +-
>  s390x/cpu.S                              |  6 ++++
>  s390x/snippets/asm/macros.S              | 28 +++++++++++++++
>  s390x/snippets/asm/snippet-pv-diag-288.S |  4 +--
>  s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++--
>  10 files changed, 140 insertions(+), 28 deletions(-)
>  create mode 100644 s390x/snippets/asm/macros.S
> 

