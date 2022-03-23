Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62634E4DBE
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbiCWIGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiCWIGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:06:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D5570F7D
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 01:05:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N6OBn2030534
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=c7YxH2DmgEInXa5Okd/n3RJIbQXmoI5Z9dyZLta8FhE=;
 b=ZJnY9PcBwZLmhnPb+JD+MThahlAHFt7Sw9E3G2a9IN9Ulh5cJFdMiueaud87J4S0vcKB
 lt/GUsBveM3dny6B86QgeCwKxlvBO3ti/mMVDUDBGiEJpbHT3dX8jcvWESujsevAmTQy
 S6IdGNtmWr3Qk6pIvb9WvkR8jS4lhF/ErG6J66uuMI3I1ueIghLxkpWiGP9JQDlGGt22
 Xt2FRArfC+mCV1auA/JP1OYhIac1xT/T/xNzgYDlaANvsfCQGKlcwSZEyc6IaYqcev3K
 JK7Fd6Hy9sOkMA/EtNBrhMRaqngdHMPR4v7++lKk4h4su7bzm0mIBTD3Lw7ibsOyLDsK /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eyx8e1nmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:05:20 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N7jSTa015829
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:05:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eyx8e1nkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:05:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N7x01F018682;
        Wed, 23 Mar 2022 08:05:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej01g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:05:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N85Gpo39715298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:05:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BABB11C066;
        Wed, 23 Mar 2022 08:05:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDA1011C06E;
        Wed, 23 Mar 2022 08:05:15 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:05:15 +0000 (GMT)
Message-ID: <ebb093d8-7aa0-a141-cb3e-4b8dfe849bd8@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH] Allow to compile without -Werror
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20220322171504.941686-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220322171504.941686-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OKDRNsHhyF63mpvtlTqsC8Zu43xmh2k2
X-Proofpoint-ORIG-GUID: J4fEJkW37eNK6YwmzUq0R2OrYZwLmQti
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=913 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 18:15, Thomas Huth wrote:
> Newer compiler versions sometimes introduce new warnings - and compiling
> with -Werror will fail there, of course. Thus users of the kvm-unit-tests
> like the buildroot project have to disable the "-Werror" in the Makefile
> with an additional patch, which is cumbersome.
> Thus let's add a switch to the configure script that allows to explicitly
> turn the -Werror switch on or off. And enable it only by default for
> developer builds (i.e. in checked-out git repositories) ... and for
> tarball releases, it's nicer if it is disabled by default, so that the
> end users do not have to worry about this.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

I'm tempted to introduce a -W-unused-* switch so the compiler doesn't 
annoy me anymore when I'm working on new things. But on the other hand 
I'd forget to disable it before submission :-)


Anyway:
Acked-by: Janosch Frank <frankja@linux.ibm.com>


> ---
>   See also the patch from the buildroot project:
>   https://git.busybox.net/buildroot/tree/package/kvm-unit-tests/0001-Makefile-remove-Werror-to-avoid-build-failures.patch
> 
>   Makefile  |  2 +-
>   configure | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 24686dd..6ed5dea 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -62,7 +62,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>   
>   COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
>   COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> -COMMON_CFLAGS += -Wignored-qualifiers -Werror -Wno-missing-braces
> +COMMON_CFLAGS += -Wignored-qualifiers -Wno-missing-braces $(CONFIG_WERROR)
>   
>   frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>   fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> diff --git a/configure b/configure
> index c4fb4a2..86c3095 100755
> --- a/configure
> +++ b/configure
> @@ -31,6 +31,13 @@ page_size=
>   earlycon=
>   efi=
>   
> +# Enable -Werror by default for git repositories only (i.e. developer builds)
> +if [ -e "$srcdir"/.git ]; then
> +    werror=-Werror
> +else
> +    werror=
> +fi
> +
>   usage() {
>       cat <<-EOF
>   	Usage: $0 [options]
> @@ -75,6 +82,8 @@ usage() {
>   	                           Specify a PL011 compatible UART at address ADDR. Supported
>   	                           register stride is 32 bit only.
>   	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
> +	    --[enable|disable]-werror
> +	                           Select whether to compile with the -Werror compiler flag
>   EOF
>       exit 1
>   }
> @@ -148,6 +157,12 @@ while [[ "$1" = -* ]]; do
>   	--disable-efi)
>   	    efi=n
>   	    ;;
> +	--enable-werror)
> +	    werror=-Werror
> +	    ;;
> +	--disable-werror)
> +	    werror=
> +	    ;;
>   	--help)
>   	    usage
>   	    ;;
> @@ -371,6 +386,7 @@ WA_DIVIDE=$wa_divide
>   GENPROTIMG=${GENPROTIMG-genprotimg}
>   HOST_KEY_DOCUMENT=$host_key_document
>   CONFIG_EFI=$efi
> +CONFIG_WERROR=$werror
>   GEN_SE_HEADER=$gen_se_header
>   EOF
>   if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then

