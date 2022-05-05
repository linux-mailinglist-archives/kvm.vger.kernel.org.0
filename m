Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B63A51C8C2
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 21:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384910AbiEETSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 15:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbiEETSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 15:18:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9944025293
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 12:14:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c14so4395035pfn.2
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 12:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e+FJ46/7Sy9VfribnYX6kNq/CwfrxVb5YsTgHdbMzYw=;
        b=RPTG4z8cakasD5OVp+30Q1BSbjyv4oUbHU8Fojvj4vDLWZeCEb/iPIxaF9Uoz9Aeqi
         1q4khR1N5XYVxxmYJiEZYDsu1AGelLC+IK2jurgtuq5vP9WTUPkWm95m9EdYHoxtuQkj
         W3s5xidBprXymtQ6qhaqNCi67LSvL18u+mJOXRYHO+E2Z2fYaqB3387lwOq65MHkD0DN
         ot/vs+zI1Od/WovlLOGqGioGy1OSVGdeVrmlXoOlCJARfIrpKixRRtaJCJf/Sn+M3i+m
         8rIHUKd+hiYwzkCHovLRDunzuoFFSvcQl3sp5Mt7crE5V57Dkb6LSdEVXvC1AAwGJeSu
         l60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e+FJ46/7Sy9VfribnYX6kNq/CwfrxVb5YsTgHdbMzYw=;
        b=23KVRcJWgI2jk86KqPS75X0q620BNyyfh06n73BPE5iSzA0LtpZfe6khFDJRr+KX9m
         768ttMtiFRKTl5WXCrjJPc7KYhnf32p9fANwQmQDKYqPI7FXE+FwBt2mBRdad1xGOems
         V0otEV97D98RxWh3w2a2N+Z77yY825OzGAtWnrJy9rcy3OD/z0xDtnX+C2sKtRL+kXS5
         qmtWzUGXtL1mZ6OD2brt4fc7wVip5jVpA5OhC0fjvndJesC8SDUb+VRzhXnbNGMBTGJD
         Yqj0jJKUc1p2liuEBBzk4Rv6ccYJImlQoXNeT6KOFy3OWO+jfGBpSEENQ2xLn260SsKF
         dvKg==
X-Gm-Message-State: AOAM530J/QfO1m7DKzigy3ikUb6VuR8VNbvilDRgMV4XuqmVmhHBzfvH
        rO6+22Ic4NX3VEbcUdjj8DXC0LqQltktoA==
X-Google-Smtp-Source: ABdhPJyT95WwbRXkrGVd4EpOotmnRFvktUdqrHky1EemmQS9SfP8FFAH2kPzRIBGRF3tuP4H20T2pQ==
X-Received: by 2002:a63:5756:0:b0:36c:67bc:7f3f with SMTP id h22-20020a635756000000b0036c67bc7f3fmr23587816pgm.389.1651778091865;
        Thu, 05 May 2022 12:14:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902b40500b0015e8d4eb29bsm1885958plr.229.2022.05.05.12.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 12:14:51 -0700 (PDT)
Date:   Thu, 5 May 2022 19:14:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v7 10/11] KVM: selftests: Test disabling NX hugepages on
 a VM
Message-ID: <YnQiKJcufscYYq/j@google.com>
References: <20220503183045.978509-1-bgardon@google.com>
 <20220503183045.978509-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183045.978509-11-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022, Ben Gardon wrote:
> +	if (disable_nx_huge_pages) {
> +		/*
> +		 * Cannot run the test without NX huge pages if the kernel
> +		 * does not support it.
> +		 */
> +		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> +			return;
> +
> +		r = __vm_disable_nx_huge_pages(vm);
> +		if (reboot_permissions) {
> +			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> +		} else {
> +			TEST_ASSERT(r == -EPERM, "This process should not have permission to disable NX huge pages");

This is wrong, the return value on ioctl() failure is -1, the error code is
in errno and it's a positive value.

LOL, but it passes because EPERM == 1, hilarious.  To avoid confusion:

			TEST_ASSERT(r == -1 && errno == EPERM,
				    "This process should not have permission to disable NX huge pages");

> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index 60bfed8181b9..c21c1f639141 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -16,6 +16,8 @@ HUGE_PAGES=$(sudo cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
>  
>  set +e
>  
> +NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
> +
>  (
>  	set -e
>  
> @@ -24,7 +26,15 @@ set +e
>  	sudo echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
>  	sudo echo 3 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  
> -	"$(dirname $0)"/nx_huge_pages_test 887563923
> +	# Test with reboot permissions
> +	sudo setcap cap_sys_boot+ep $NXECUTABLE

This leaves cap_sys_boot set on the executable if the script is run as root.

Probably this?  It's moderately user friendly without going too crazy on error
handling.

	# Test with reboot permissions
	if [ $(whoami) != "root" ] ; then
		sudo setcap cap_sys_boot+ep $NXECUTABLE
	fi
	$NXECUTABLE 887563923 1

	# Test without reboot permissions
	if [ $(whoami) != "root" ] ; then
		sudo setcap cap_sys_boot-ep $NXECUTABLE
		$NXECUTABLE 887563923 0
	fi

> +	$NXECUTABLE 887563923 1
> +
> +	# Test without reboot permissions
> +	if [ $(whoami) != "root" ] ; then
> +		sudo setcap cap_sys_boot-ep $NXECUTABLE
> +		$NXECUTABLE 887563923 0

I would much prefer a proper flag, not a magic 0 vs. 1.  

> +	fi
>  )
>  RET=$?
>  
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 
