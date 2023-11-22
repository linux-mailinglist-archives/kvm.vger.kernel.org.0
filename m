Return-Path: <kvm+bounces-2250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BF97F3E9E
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 523C9B21060
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 07:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278FE1863E;
	Wed, 22 Nov 2023 07:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C387090;
	Tue, 21 Nov 2023 23:10:44 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id F058267373; Wed, 22 Nov 2023 08:10:40 +0100 (CET)
Date: Wed, 22 Nov 2023 08:10:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: linux-next: manual merge of the kvm tree with the vfs-brauner
 tree
Message-ID: <20231122071040.GA4104@lst.de>
References: <20231122125539.5a7df3a3@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122125539.5a7df3a3@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 22, 2023 at 12:55:39PM +1100, Stephen Rothwell wrote:
> index 06142ff7f9ce,bf2965b01b35..000000000000
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@@ -203,9 -203,8 +203,10 @@@ enum mapping_flags 
>   	/* writeback related tags are not used */
>   	AS_NO_WRITEBACK_TAGS = 5,
>   	AS_LARGE_FOLIO_SUPPORT = 6,
> - 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
> + 	AS_RELEASE_ALWAYS = 7,	/* Call ->release_folio(), even if no private data */
> + 	AS_UNMOVABLE	= 8,	/* The mapping cannot be moved, ever */
>  +	AS_STABLE_WRITES,	/* must wait for writeback before modifying
>  +				   folio contents */
>   };

Note that AS_STABLE_WRITES, is a fix for 6.7, so this will probably
end up getting reordered.  It might also be worth to remove all the
explicit number assignments here to make the merge conflict resolution
a bit easier in the future.

