Return-Path: <kvm+bounces-5189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FB581D08A
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 00:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 199142859F9
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 23:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694C835F0F;
	Fri, 22 Dec 2023 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hYfvJyQb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A47D33CFE;
	Fri, 22 Dec 2023 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703288484; x=1734824484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VYldxlNfCDK2XZRBuiMTRKlwofmXO4n507rdIZtn5hQ=;
  b=hYfvJyQbBfZAdFnVoXI85k+25XrK6hNRSyU5TW/bxWr3p4NKO0fO3h0x
   F39Anp1q3KRAzX9z6Vchu/uXeg/rUE5cpSzFM4fgocvbbCvgWl5Q0AE7f
   YQNA5A619cGaHK0u4kxgY1o5sRzNo/VtBKQmIFlhNv/jHN0m5LKGlV8ZD
   1rhvVzj8vA1ydLptZvIb1wUjxicqVJiD8tO5+N1NLFOv5vIrMw+s/bXm4
   MAvIztVP+zUesXl477FAx5UM4RdFxl4PNiaffLkkp9hhc3qnetQ3oAU3D
   3m8v1y26HSWEloN3AbNS0UMt8e4fxAeND7jmzuJ1DwzJ46TqPJiS/os0Q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="3007880"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="3007880"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 15:41:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="950449947"
X-IronPort-AV: E=Sophos;i="6.04,297,1695711600"; 
   d="scan'208";a="950449947"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 22 Dec 2023 15:41:19 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rGp8j-000A0N-17;
	Fri, 22 Dec 2023 23:41:14 +0000
Date: Sat, 23 Dec 2023 07:39:30 +0800
From: kernel test robot <lkp@intel.com>
To: Mina Almasry <almasrymina@google.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Mina Almasry <almasrymina@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Shakeel Butt <shakeelb@google.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
Message-ID: <202312230739.g0Tfssdt-lkp@intel.com>
References: <20231220214505.2303297-4-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220214505.2303297-4-almasrymina@google.com>

Hi Mina,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Mina-Almasry/vsock-virtio-use-skb_frag_-helpers/20231222-164637
base:   net-next/main
patch link:    https://lore.kernel.org/r/20231220214505.2303297-4-almasrymina%40google.com
patch subject: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
config: i386-randconfig-141-20231222 (https://download.01.org/0day-ci/archive/20231223/202312230739.g0Tfssdt-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231223/202312230739.g0Tfssdt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312230739.g0Tfssdt-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/kcm/kcmsock.c: In function 'kcm_write_msgs':
>> net/kcm/kcmsock.c:637:59: error: 'skb_frag_t' {aka 'struct skb_frag'} has no member named 'bv_len'
     637 |                         msize += skb_shinfo(skb)->frags[i].bv_len;
         |                                                           ^


vim +637 net/kcm/kcmsock.c

cd6e111bf5be5c Tom Herbert       2016-03-07  578  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  579  /* Write any messages ready on the kcm socket.  Called with kcm sock lock
ab7ac4eb9832e3 Tom Herbert       2016-03-07  580   * held.  Return bytes actually sent or error.
ab7ac4eb9832e3 Tom Herbert       2016-03-07  581   */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  582  static int kcm_write_msgs(struct kcm_sock *kcm)
ab7ac4eb9832e3 Tom Herbert       2016-03-07  583  {
c31a25e1db486f David Howells     2023-06-09  584  	unsigned int total_sent = 0;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  585  	struct sock *sk = &kcm->sk;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  586  	struct kcm_psock *psock;
c31a25e1db486f David Howells     2023-06-09  587  	struct sk_buff *head;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  588  	int ret = 0;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  589  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  590  	kcm->tx_wait_more = false;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  591  	psock = kcm->tx_psock;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  592  	if (unlikely(psock && psock->tx_stopped)) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  593  		/* A reserved psock was aborted asynchronously. Unreserve
ab7ac4eb9832e3 Tom Herbert       2016-03-07  594  		 * it and we'll retry the message.
ab7ac4eb9832e3 Tom Herbert       2016-03-07  595  		 */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  596  		unreserve_psock(kcm);
cd6e111bf5be5c Tom Herbert       2016-03-07  597  		kcm_report_tx_retry(kcm);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  598  		if (skb_queue_empty(&sk->sk_write_queue))
ab7ac4eb9832e3 Tom Herbert       2016-03-07  599  			return 0;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  600  
c31a25e1db486f David Howells     2023-06-09  601  		kcm_tx_msg(skb_peek(&sk->sk_write_queue))->started_tx = false;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  602  	}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  603  
c31a25e1db486f David Howells     2023-06-09  604  retry:
c31a25e1db486f David Howells     2023-06-09  605  	while ((head = skb_peek(&sk->sk_write_queue))) {
c31a25e1db486f David Howells     2023-06-09  606  		struct msghdr msg = {
c31a25e1db486f David Howells     2023-06-09  607  			.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES,
c31a25e1db486f David Howells     2023-06-09  608  		};
c31a25e1db486f David Howells     2023-06-09  609  		struct kcm_tx_msg *txm = kcm_tx_msg(head);
c31a25e1db486f David Howells     2023-06-09  610  		struct sk_buff *skb;
c31a25e1db486f David Howells     2023-06-09  611  		unsigned int msize;
c31a25e1db486f David Howells     2023-06-09  612  		int i;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  613  
c31a25e1db486f David Howells     2023-06-09  614  		if (!txm->started_tx) {
c31a25e1db486f David Howells     2023-06-09  615  			psock = reserve_psock(kcm);
c31a25e1db486f David Howells     2023-06-09  616  			if (!psock)
c31a25e1db486f David Howells     2023-06-09  617  				goto out;
c31a25e1db486f David Howells     2023-06-09  618  			skb = head;
c31a25e1db486f David Howells     2023-06-09  619  			txm->frag_offset = 0;
c31a25e1db486f David Howells     2023-06-09  620  			txm->sent = 0;
c31a25e1db486f David Howells     2023-06-09  621  			txm->started_tx = true;
c31a25e1db486f David Howells     2023-06-09  622  		} else {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  623  			if (WARN_ON(!psock)) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  624  				ret = -EINVAL;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  625  				goto out;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  626  			}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  627  			skb = txm->frag_skb;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  628  		}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  629  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  630  		if (WARN_ON(!skb_shinfo(skb)->nr_frags)) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  631  			ret = -EINVAL;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  632  			goto out;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  633  		}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  634  
c31a25e1db486f David Howells     2023-06-09  635  		msize = 0;
c31a25e1db486f David Howells     2023-06-09  636  		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
c31a25e1db486f David Howells     2023-06-09 @637  			msize += skb_shinfo(skb)->frags[i].bv_len;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  638  
b2e5852793b6eb Mina Almasry      2023-12-20  639  		/* The cast to struct bio_vec* here assumes the frags are
b2e5852793b6eb Mina Almasry      2023-12-20  640  		 * struct page based. WARN if there is no page in this skb.
b2e5852793b6eb Mina Almasry      2023-12-20  641  		 */
b2e5852793b6eb Mina Almasry      2023-12-20  642  		DEBUG_NET_WARN_ON_ONCE(
b2e5852793b6eb Mina Almasry      2023-12-20  643  			!skb_frag_page(&skb_shinfo(skb)->frags[0]));
b2e5852793b6eb Mina Almasry      2023-12-20  644  
c31a25e1db486f David Howells     2023-06-09  645  		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
b2e5852793b6eb Mina Almasry      2023-12-20  646  			      (const struct bio_vec *)skb_shinfo(skb)->frags,
b2e5852793b6eb Mina Almasry      2023-12-20  647  			      skb_shinfo(skb)->nr_frags, msize);
c31a25e1db486f David Howells     2023-06-09  648  		iov_iter_advance(&msg.msg_iter, txm->frag_offset);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  649  
c31a25e1db486f David Howells     2023-06-09  650  		do {
264ba53fac79b0 David Howells     2023-06-09  651  			ret = sock_sendmsg(psock->sk->sk_socket, &msg);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  652  			if (ret <= 0) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  653  				if (ret == -EAGAIN) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  654  					/* Save state to try again when there's
ab7ac4eb9832e3 Tom Herbert       2016-03-07  655  					 * write space on the socket
ab7ac4eb9832e3 Tom Herbert       2016-03-07  656  					 */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  657  					txm->frag_skb = skb;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  658  					ret = 0;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  659  					goto out;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  660  				}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  661  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  662  				/* Hard failure in sending message, abort this
ab7ac4eb9832e3 Tom Herbert       2016-03-07  663  				 * psock since it has lost framing
71a2fae50895b3 Bhaskar Chowdhury 2021-03-27  664  				 * synchronization and retry sending the
ab7ac4eb9832e3 Tom Herbert       2016-03-07  665  				 * message from the beginning.
ab7ac4eb9832e3 Tom Herbert       2016-03-07  666  				 */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  667  				kcm_abort_tx_psock(psock, ret ? -ret : EPIPE,
ab7ac4eb9832e3 Tom Herbert       2016-03-07  668  						   true);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  669  				unreserve_psock(kcm);
9f8d0dc0ec4a4b David Howells     2023-06-15  670  				psock = NULL;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  671  
c31a25e1db486f David Howells     2023-06-09  672  				txm->started_tx = false;
cd6e111bf5be5c Tom Herbert       2016-03-07  673  				kcm_report_tx_retry(kcm);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  674  				ret = 0;
c31a25e1db486f David Howells     2023-06-09  675  				goto retry;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  676  			}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  677  
c31a25e1db486f David Howells     2023-06-09  678  			txm->sent += ret;
c31a25e1db486f David Howells     2023-06-09  679  			txm->frag_offset += ret;
cd6e111bf5be5c Tom Herbert       2016-03-07  680  			KCM_STATS_ADD(psock->stats.tx_bytes, ret);
c31a25e1db486f David Howells     2023-06-09  681  		} while (msg.msg_iter.count > 0);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  682  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  683  		if (skb == head) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  684  			if (skb_has_frag_list(skb)) {
c31a25e1db486f David Howells     2023-06-09  685  				txm->frag_skb = skb_shinfo(skb)->frag_list;
c31a25e1db486f David Howells     2023-06-09  686  				txm->frag_offset = 0;
c31a25e1db486f David Howells     2023-06-09  687  				continue;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  688  			}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  689  		} else if (skb->next) {
c31a25e1db486f David Howells     2023-06-09  690  			txm->frag_skb = skb->next;
c31a25e1db486f David Howells     2023-06-09  691  			txm->frag_offset = 0;
c31a25e1db486f David Howells     2023-06-09  692  			continue;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  693  		}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  694  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  695  		/* Successfully sent the whole packet, account for it. */
c31a25e1db486f David Howells     2023-06-09  696  		sk->sk_wmem_queued -= txm->sent;
c31a25e1db486f David Howells     2023-06-09  697  		total_sent += txm->sent;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  698  		skb_dequeue(&sk->sk_write_queue);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  699  		kfree_skb(head);
cd6e111bf5be5c Tom Herbert       2016-03-07  700  		KCM_STATS_INCR(psock->stats.tx_msgs);
c31a25e1db486f David Howells     2023-06-09  701  	}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  702  out:
ab7ac4eb9832e3 Tom Herbert       2016-03-07  703  	if (!head) {
ab7ac4eb9832e3 Tom Herbert       2016-03-07  704  		/* Done with all queued messages. */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  705  		WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
9f8d0dc0ec4a4b David Howells     2023-06-15  706  		if (psock)
ab7ac4eb9832e3 Tom Herbert       2016-03-07  707  			unreserve_psock(kcm);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  708  	}
ab7ac4eb9832e3 Tom Herbert       2016-03-07  709  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  710  	/* Check if write space is available */
ab7ac4eb9832e3 Tom Herbert       2016-03-07  711  	sk->sk_write_space(sk);
ab7ac4eb9832e3 Tom Herbert       2016-03-07  712  
ab7ac4eb9832e3 Tom Herbert       2016-03-07  713  	return total_sent ? : ret;
ab7ac4eb9832e3 Tom Herbert       2016-03-07  714  }
ab7ac4eb9832e3 Tom Herbert       2016-03-07  715  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

