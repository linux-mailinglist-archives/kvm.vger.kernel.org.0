Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA859C398
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 18:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiHVQBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiHVQAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 12:00:48 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5095F15A38
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 09:00:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 2so10355950pll.0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 09:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Eusj5tRM9kHkp0fXxuOOeVVvjzsgsdMohVFpv8zrLO4=;
        b=cQyu75g/cav4GQAjP/WFxwtJxNW8VZmv3fp1w4YDEmZ4de270lSdk7jaTICAtxFBT0
         bspKfS7XijoVt3aiWe0v6mUfwrTsQZ9q4SnlJ4qABDAY+DLiLCnGUmescm0Lis5SwU3f
         R6mrpB5h/jTR0+8+JRmONZQxGjNbmFK4+EqW3as2dks6zno7VUy/b0AA5cb18YpbrZTr
         ZV7SySP1+LT9ZLkpM/bjJhczWSsGEJQxPw9/FgetzMOKsuRK6e3MOuNmjipZFcjKlsHf
         6TkxQlC/55P89aJwRmFAOiW8beu0W4n6zHTXnbr//GyndxAki9BoBpqk2oN965pV5K8u
         DuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Eusj5tRM9kHkp0fXxuOOeVVvjzsgsdMohVFpv8zrLO4=;
        b=dfQFxfyq+Ok9Hc+5wSv98R3cVahGhFyy8Pi1RrxvnFHf2ZQniTi1pYDrgh3kNSMtsK
         SuA87YdGqy7UEEhjHmKcqApVM7YimJr3ypR5SnFu+DRKL0tfKjGqvd8B8a7RZKEsdjfu
         6uanOq66NSZ555HsTLViYBBNixlrKyjICOPKC4oKSOCGQg3zlhCI0FAmE2wgic47Jkpk
         Mi+F1eA4KKEF1TSlF8WulnoCGoxcoGO1/NEctsWP8k+06LFD2ICKeI0CNZOIZXUdj266
         H7kx6v+BaeB62UsyMN26YCq/Opg88TTFgaIFR2l6abmKcPRyzPIaEFYR1/PwaWV6VyM2
         uq7Q==
X-Gm-Message-State: ACgBeo1vgTUxSqod3nyAc3h500DH5P2GF5+3x97H/8NPcMLlvbeAeluy
        vNL3HVUXUJ0r4qptlA8jmU0P0A==
X-Google-Smtp-Source: AA6agR6fCF0L6EVpaGRYH0oYC7Z/nnw1ZkOquqr0XVyEDXvA/D2z9UwNWnUew/rZ57W3EBNWQSBhhw==
X-Received: by 2002:a17:903:187:b0:172:dc6b:5ec6 with SMTP id z7-20020a170903018700b00172dc6b5ec6mr9390423plg.95.1661184046711;
        Mon, 22 Aug 2022 09:00:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id nk24-20020a17090b195800b001fb3522d53asm1837027pjb.34.2022.08.22.09.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:00:46 -0700 (PDT)
Date:   Mon, 22 Aug 2022 16:00:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     cgel.zte@gmail.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: Re: [PATCH linux-next v2] KVM: SVM: Remove the unneeded result
 variable
Message-ID: <YwOoKk5PLnEDGI2A@google.com>
References: <20220822013720.199757-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822013720.199757-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Return the value from sev_guest_activate(&activate, error) and
> sev_issue_cmd_external_user(f.file, id, data, error) directly
> instead of storing it in another redundant variable.And also change
> the position of handle and asid to simplify the code.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
> v1 -> v2
> Suggested-by: SeanChristopherson <seanjc@google.com>
> 
> Change the position of handle and asid.
> Change the explain about this patch.
> Dropping the comment about asid + handle.
>  arch/x86/kvm/svm/sev.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 28064060413a..4448f2e512b9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -276,31 +276,24 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>  {
> -	struct sev_data_activate activate;
> -	int asid = sev_get_asid(kvm);
> -	int ret;
> -
> -	/* activate ASID on the given handle */
> -	activate.handle = handle;
> -	activate.asid   = asid;
> -	ret = sev_guest_activate(&activate, error);
> +	struct sev_data_activate activate = {
> +		.handle = handle,
> +		.asid = sev_get_asid(kvm),
> +	};
>  
> -	return ret;
> +	return sev_guest_activate(&activate, error);
>  }
>  
>  static int __sev_issue_cmd(int fd, int id, void *data, int *error)
>  {
>  	struct fd f;
> -	int ret;
>  
>  	f = fdget(fd);
>  	if (!f.file)
>  		return -EBADF;
>  
> -	ret = sev_issue_cmd_external_user(f.file, id, data, error);
> -
>  	fdput(f);
> -	return ret;
> +	return sev_issue_cmd_external_user(f.file, id, data, error);

Again, this is broken, the fdput() needs to stay after f.file is consumed, i.e.
eliminating "ret" is wrong.

>  }
>  
>  static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
> -- 
> 2.25.1
