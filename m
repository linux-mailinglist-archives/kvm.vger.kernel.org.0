Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1C718E4E
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjEaWQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjEaWQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:16:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66996199
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:15:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso175979276.2
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685571353; x=1688163353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eo+YCgcGqkBuJ621oJwDDbLDY7sHKVgnWdI9fSJm6aE=;
        b=DAdvLHlVY0Zf2cU6l9SR3oYslndchPDrlwi2MJ+tG/tXri4C+lDDjOUPo5PwCDnv+z
         s/idDiIVgfKBa2yDuRc642vcYFE0ozXBkXCIQMmFqoWP3LdxIcBQEVpV42MpDLsw5OKp
         VBhJ7l+vKDU2BhqxLUjauGjisg4si+9v0iDIkFxGbRlVEImKqf3V13GRFPowMk0gQkXT
         8BwwLyPAjh8zqBv1YM1Sv9lsvXSuBtzJ/YDGYD9NaUUh+ESNTMU/jD+xjKt6Po1S5vqk
         DR/ot4MSFDpqfNlF25tllsiWbSyDVrR6HCzGA5d09TkEJWDlQtub2AT6PJMpOSyJif9t
         aSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685571353; x=1688163353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eo+YCgcGqkBuJ621oJwDDbLDY7sHKVgnWdI9fSJm6aE=;
        b=JOAIxmvaL7y2HSmUivDgT39rzMT2rXlDpNFzjJwLNIWhg6HSGbYFoNO62lEfUPs9qm
         SEkqC8yj0Bj21kqs765hRmuxMFAwohvNFwwsOSHYHJ4YCjwFXi28FMX9VzvRNEBGyQtM
         VLcR4BSDIT2/nniqsIF4Chl/H/e9qXPWpo6NxexjMYj+OWb0HV7XznuepcdBO2/Cre1z
         FNTBMBytpA3oZ1IneL5h49CccMAhNsZNSpR6eCBz22LKxj595GlfPZmp11dK7D/97OBS
         Yza/Q2J9uZ+ubgkXuSSrMEUDcCbzTvM+q7v5/NK3iFtPVkiqXso7D8XO7m/H183/FXd2
         ce2w==
X-Gm-Message-State: AC+VfDyNmzWxs3/sUp8KoDK4NNsNrdHvZqk62IJfEqM+q/sk7W2+AmKG
        lyjQNsUqGodwM5a8pdxKItxpnKWbaCY=
X-Google-Smtp-Source: ACHHUZ718jRsL8DjvPJNkaxW+KwPycXLNn5BZlg+8b4sF7VAjfogITOXJBab9oMQK7Pm9Z3VrJ4ym6bWpYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1022:b0:bb1:3606:6a29 with SMTP id
 x2-20020a056902102200b00bb136066a29mr2100507ybt.3.1685571353284; Wed, 31 May
 2023 15:15:53 -0700 (PDT)
Date:   Wed, 31 May 2023 15:15:52 -0700
In-Reply-To: <20230503233812.2743269-1-peterx@redhat.com>
Mime-Version: 1.0
References: <20230503233812.2743269-1-peterx@redhat.com>
Message-ID: <ZHfHGCfsz4dSQ62b@google.com>
Subject: Re: [PATCH] selftests/kvm: Allow specify physical cpu list in demand
 paging test
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Peter Xu wrote:
> Mimic dirty log test to allow specify physical cpu pinning for vcpu threads.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index bdb8e0748154..d709b65fda2f 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -220,12 +220,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  static void help(char *name)
>  {
>  	puts("");
> -	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
> +	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a] [-c cpu_list]\n"
>  		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
>  		   "          [-s type] [-v vcpus] [-o]\n", name);
>  	guest_modes_help();
>  	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
>  	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> +	printf(" -c: physical cores to pin vcpu threads (e.g. 1,2,3,...)\n");

This help really should be provided by kvm_util.c, e.g. this doesn't capture the
"must pin all vCPUs" behavior, nor does it capture the "pin the main thread"
behavior.

Something like this?

void kvm_get_vcpu_pinning_help(char *buffer, size_t size,
			       const char *optchar, const char *testname)
{
	snprintf(buffer, size,
		 " -%c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
		 "     values (target pCPU), one for each vCPU, plus an optional\n"
		 "     entry for the main application task (specified via entry\n"
		 "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
		 "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
		 "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
		 "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
		 "         ./%s -v 3 -c 22,23,24,50\n\n"
		 "     To leave the application task unpinned, drop the final entry:\n\n"
		 "         ./%s -v 3 -c 22,23,24\n\n"
		 "     (default: no pinning)\n", optchar, testname);
}
