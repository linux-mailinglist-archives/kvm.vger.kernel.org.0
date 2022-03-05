Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BEC4CE720
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 22:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiCEVI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 16:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiCEVI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 16:08:26 -0500
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FD926CC
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 13:07:35 -0800 (PST)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id 0C8AC805C5;
        Sat,  5 Mar 2022 21:07:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 464A26000B;
        Sat,  5 Mar 2022 21:07:26 +0000 (UTC)
Message-ID: <5104a7ff8bcb00ffa439cbe4ea7990a65a2f2e73.camel@perches.com>
Subject: Re: [PATCH 6/6] KVM: Fix minor indentation and brace style issues
From:   Joe Perches <joe@perches.com>
To:     Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 13:07:27 -0800
In-Reply-To: <20220305205528.463894-7-henryksloan@gmail.com>
References: <20220305205528.463894-1-henryksloan@gmail.com>
         <20220305205528.463894-7-henryksloan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 464A26000B
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: f6mhb7mguf4339n8cwt8iydpn8xqakhs
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+lz2A3N6jA9UaRenuPpd+B2Zi8vl/0U/c=
X-HE-Tag: 1646514446-927920
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-03-05 at 15:55 -0500, Henry Sloan wrote:
> Signed-off-by: Henry Sloan <henryksloan@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 36 +++++++++++++++++++-----------------
>  virt/kvm/pfncache.c |  2 +-
>  2 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
[]
> @@ -2154,9 +2157,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
>  
>  	if (log->first_page > memslot->npages ||
> -	    log->num_pages > memslot->npages - log->first_page ||
> -	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
> -	    return -EINVAL;
> +		log->num_pages > memslot->npages - log->first_page ||
> +		(log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
> +		return -EINVAL;

The change to indentation on the return statement is good
but the change to the indentation on the if statement block is not.

Perhaps a better change might be:

	if (log->first_page > memslot->npages ||
	    log->num_pages > memslot->npages - log->first_page ||
	    (log->num_pages < memslot->npages - log->first_page &&
	     (log->num_pages & 63)))
		return -EINVAL;

>  
>  	kvm_arch_sync_dirty_log(kvm, memslot);
>  
> @@ -2517,7 +2520,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  	 * tail pages of non-compound higher order allocations, which
>  	 * would then underflow the refcount when the caller does the
>  	 * required put_page. Don't allow those pages here.
> -	 */ 
> +	 */
>  	if (!kvm_try_get_pfn(pfn))
>  		r = -EFAULT;
>  
> @@ -2906,7 +2909,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
>  
>  static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> -			           void *data, int offset, unsigned long len)
> +						void *data, int offset, unsigned long len)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2923,7 +2926,7 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
>  }
>  
>  int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
> -			       void *data, unsigned long len)
> +						void *data, unsigned long len)

These whitespace changes are somewhat odd and unnecessary.
It's generally preferred to align to arguments to the open parenthesis.


