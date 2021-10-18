Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B73432489
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhJRRTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhJRRTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 13:19:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7810EC061745
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:17:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y7so15226831pfg.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FTqdM6SYdB5c8YPj/tHS3P7Dcj4ilqGB0gV45sGeKJQ=;
        b=QJJsmgBDnRLpYtOzZb0bQLJtFzBbvduiNpm+4JWhTAI5qhRNUIPecl8KHGL0l3KU/v
         u/yNOcStNDVuJAAtaZZv36h2u7cBL6Tn5Cs2PM6flkIZERNsXhg8DZ6f1tLanT1bnpMS
         t+RAkytFsLWfJ9UzOlTey72cOJrIrizJDOYSVgm/s8UFkM2xuDXMgH/qph6XvItKUmRs
         RxXo/93RqqUkxvoKSiFZcb0JCx0kIswU0BzhuOsXz7O2/XMRfGRfWYBdFJkE2EjC4YIa
         DcdhexKR0zwEIoVuaWbEP4k1JtsHMTIAOINK4flcXN43PcIMuQvBaPT+/0/IEcKxQz+P
         Lw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FTqdM6SYdB5c8YPj/tHS3P7Dcj4ilqGB0gV45sGeKJQ=;
        b=cXv83Cv1swX5P22K8KeaiW/ucXZ2KqZCF9V7p1PMuh7zlqtvUFENxi7BXxl8gzyA5g
         JVj88S7df7SXVgcbnX07lRYswJQClCc6mCmJt+MjFBO8OSXibVpCamG5fUl7QME1w61n
         XSNHZ7tE/t9YOtOpaq8oL2wgjKCRDhwhLsma9c3zJlrYwDDjaUXe8kI0kkhxVGAASnVr
         QZwZrePCo5OFTi44ltSA75hBrMru5SL8J2/brCmt4DjzzkXNhZZ3o3iAk9aYbW/D+7Py
         K62x6Y0pOgLhuskFOR4M/Ugw9HM6Z8rKPCey2zEw0OnlGb+x3ofj7KXOSkufID5w6SOB
         G3bA==
X-Gm-Message-State: AOAM531r95+xTL2NW2M+SiT7KgaKje+C2VhTuC0XS9xXHqpeRDCol1Cc
        2ILnsDyDRzv9ksXVnAE55DKWVw==
X-Google-Smtp-Source: ABdhPJxhNHp8lZjfGLIpaD4MQ2WQkT20n84OiMJVEFmHM0yBBF1h/9MtVrLabeaRVb0Ddg1/SZpF2g==
X-Received: by 2002:a62:31c5:0:b0:447:b30c:9a79 with SMTP id x188-20020a6231c5000000b00447b30c9a79mr30007383pfx.67.1634577454796;
        Mon, 18 Oct 2021 10:17:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v13sm13690901pgt.7.2021.10.18.10.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:17:33 -0700 (PDT)
Date:   Mon, 18 Oct 2021 17:17:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, x86@kernel.org, yang.zhong@intel.com,
        jarkko@kernel.org, bp@suse.de
Subject: Re: [PATCH v3 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-ID: <YW2sKq1pXkuiG1rb@google.com>
References: <20211016071434.167591-1-pbonzini@redhat.com>
 <20211016071434.167591-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211016071434.167591-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
> +{
> +	struct sgx_epc_page *entry;
> +	unsigned long index;
> +	long failures = 0;
> +
> +	xa_for_each(&vepc->page_array, index, entry) {
> +		int ret = sgx_vepc_remove_page(entry);
> +		if (ret) {
> +			if (ret == SGX_CHILD_PRESENT) {

There's a ton of documentation in the changelog and official docs, but a comment
here would also be helpful.

> +				failures++;
> +			} else {
> +				/*
> +				 * Unlike in sgx_vepc_free_page, userspace might
> +				 * call the ioctl while logical processors are
> +				 * running in the enclave, or cause faults due
> +				 * to concurrent access to pages under the same
> +				 * SECS.  So we cannot warn, we just report it.

Technically the kernel can WARN on #PF[*], as EREMOVE only hits #PF if there's a
legitimate #PF or if the target page is not an EPC page.  FWIW, the comments are
a little less compressed if the if statements aren't nested.

		if (ret == SGX_CHILD_PRESENT) {
			/*
			 * Track and return the number of SECS pages that cannot
			 * be removed because they have child EPC pages (in this
			 * vEPC or a different vEPC).
			 */
			failures++;
		} else if (ret) {
			/*
			 * Report errors due to #GP or SGX_ENCLAVE_ACT, but do
			 * not WARN as userspace can induce said failures by
			 * calling the ioctl concurrently on multiple vEPCs or
			 * while one or more CPUs is running the enclave.  Only
			 * a #PF on EREMOVE indicates a kernel/hardware issue.
			 */
			WARN_ON_ONCE(encls_faulted(ret) &&
				     ENCLS_TRAPNR(ret) == X86_TRAP_PF);
			return -EBUSY;
		}

[*] SGX1 hardware has an erratum where it signals #GP instead of #PF, but that's
    ok in this case because it's a false negative, not a false positive.

> +				 */
> +				return -EBUSY;
> +			}
> +		}
> +		cond_resched();
> +	}
> +
> +	/*
> +	 * Return the number of pages that failed to be removed, so
> +	 * userspace knows that there are still SECS pages lying
> +	 * around.

Nit, the comment doesn't need to span three lines.

	/*
	 * Return the number of pages that failed to be removed, so userspace
	 * knows that there are still SECS pages lying around.
	 */

> +	 */
> +	return failures;
> +}
