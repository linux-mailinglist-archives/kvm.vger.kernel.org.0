Return-Path: <kvm+bounces-65906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A4696CBA0D6
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D27C1301A95F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCD330F534;
	Fri, 12 Dec 2025 23:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKkZNzUD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BA1E4BE;
	Fri, 12 Dec 2025 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765582644; cv=none; b=B5jYOScBfq8CcA0Vk9q9NIJCocyO/NjPf+bAXznm9vW0/890XzzcHDzuXJpe4FCzRfhtq7tdbzGlQ3w1tsEaixyAsE6Nt9JQH32Nd4G10zvVZzWePhRBEAYooIGae0u0Zyy+6Ptrn/DLhylTKBQqeQqk2GMW9xKs4ly0958Dano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765582644; c=relaxed/simple;
	bh=RnNBth3zFPDybQ5SK+aP72ZOJeINc0ldHHmonazGgFI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFP/sQHwBvw9OTdI59G39AnOp+w/AO8Ngh4FCvKjCS3vDOxanXbgoGmcV+MVwxuMhwK3QvPJ+AbX9KHxySSj+6fz5sCc05eJ21ABiIxG5AWHA72+QfJy7Dgqo8i6SaZebAD1Ltcpnhosv+QkOUqna8zPb6DR3yd8TbVoBs3xNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKkZNzUD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AADC4CEF1;
	Fri, 12 Dec 2025 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765582643;
	bh=RnNBth3zFPDybQ5SK+aP72ZOJeINc0ldHHmonazGgFI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YKkZNzUDZ94nMV0srBwMYrpcOSCN8ky7WFO355LtaXbWTFwIC2yetK4Ql6FW5lPHm
	 RvhNA7E+BdfsvN8wlp5/TA5wwTsA3HNM2TQuP/xaxRo6eDJZa2MwjGT9lIjnZBIZkT
	 3xAjZ0feF6uARkNZmYyJq6zt34Kkx2dvKI6bKQt1Sl2zNura0xCaMLj0pM0NITZuyC
	 /dJxCAVIqp6ccGb9UGPMUltiH/rovWz1+jnW2c0g6C6HL4UO/ZSfS7Qs5wPGrjYi7P
	 L6fzkivQ1htpnx7W48o1Nkw/1IXWmVKHC7WJZ2fc3iYU7p/0zvD8ukmxvdLVYfcVea
	 VW/gL3EI3r0DA==
Date: Sat, 13 Dec 2025 08:37:17 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
 syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v4] net: restore the iterator to its original
 state when an error occurs
Message-ID: <20251213083717.44fb78c4@kernel.org>
In-Reply-To: <tencent_D6C4465761B77986C7B36FA368E97E23A805@qq.com>
References: <tencent_D6C4465761B77986C7B36FA368E97E23A805@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 14:57:08 +0800 Edward Adam Davis wrote:
> In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> and the first one succeeds while the second one fails, it returns a
> failure but the count in iterator has already been decremented due to
> the first successful copy. This ultimately affects the local variable
> rest_len in virtio_transport_send_pkt_info(), causing the remaining
> count in rest_len to be greater than the actual iterator count. As a
> result, packet sending operations continue even when the iterator count
> is zero, which further leads to skb->len being 0 and triggers the warning
> reported by syzbot [1].

Please address the feedback from previous revision and when you repost
use net as the subject tag.
-- 
pw-bot: cr

