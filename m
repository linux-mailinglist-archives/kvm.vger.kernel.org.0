Return-Path: <kvm+bounces-65934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E18CBB620
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 03:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05CD8300C6D7
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 02:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0B72E2840;
	Sun, 14 Dec 2025 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="XocoTaQl"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CA01FF5F9;
	Sun, 14 Dec 2025 02:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765680670; cv=none; b=CQzT0DdVwKatkAM3W50GA2QysFBNvp1tMQCNrgqY3uUgR16slWgdQ6uVs9kMt03OhMmrUGyxHpsUHL78RFE/b1D10oyIcL29CsezSNq+Zi6zwhuuVeMMzCPY02WIKIxSTtli/fxj/PD2jbg2b+PNzzngREgVzRoTexzwlqh6s4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765680670; c=relaxed/simple;
	bh=nN7B3Qdh5Nc5GqxXdyl95sJL9td2JS18OMmoBxYKWTM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=RQ/O5sskbz7HP94bwW2YVw6W/L5D38z73s5viChQzYfAaq1x6t28GQlmmoNuZkqAi6/zUnz62m0hxKWbYvda2dwZWwFhDq13Hju8OvgIGVeMfo10Bf9IiP4cBYoKlnkDsHoh6MmkxFqFJjvxXqVN6cICo0YAU8HXsaoVmNz6DvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=XocoTaQl; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765680651; bh=K2OZpHYHYZfWcCHPoZC/EThAw3ioCUEy54sUZxS6dz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XocoTaQlMp5YNN3ATvj8AlD+7kbJW8o64JjjCPBDLfKSt5APMVR1scFuGtJqL6zyO
	 ID3MG45lpkLx5SX529JlGhXgbnYf+hYpAWnF+asMOEsx3eqwmKktPbGhXoQDKxGKRP
	 Z0H7hSVmCo2u5zg3BCo+/IldOThob4Wpetuc+bag=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id C62A4629; Sun, 14 Dec 2025 10:49:34 +0800
X-QQ-mid: xmsmtpt1765680574tmqa0m9qx
Message-ID: <tencent_922CC96DE097F8E8EAECA6CED47BCA6C840A@qq.com>
X-QQ-XMAILINFO: NQp/UN4soYLTE6XaGnoCUWXJp5y/lq1f7iO2t7sZtSbsh4Qdr/QfObtsCXPKAy
	 73IUanxQx0OLkY2WTV931kJDMcjliNFTQdvhiKGPrbFC2Bq04eC821g1s9FjwndJd4Cl6dqEnQYG
	 5u0hoX8lHX1/DHMUguz5i6Q4d+gRyNIhxPrTxFePG2SAWXEY2YWRXhGRuJABh66NbGFQsMniDRrG
	 U2PRsZhGnH4cL4ojz6o/zsJX5hZWdrwyWlWLUmtqkvdOvCM9hal3v9uLkE3qCeDCJLR8rEorg0tK
	 e64pG9C5HzgK7UgbIBI7eUWg4uN5nI8kU9XPVHJVG0ksiSZtZ4jHdLbTDzquVtcucHBqJNCphbDD
	 Xq4UAF5Gn7ky6IJKgJX8n5s/d04MNDG86vj+IrR+NxpLx3Z3/k5SlpnKqiD6ZDpVFRJpspbQboIB
	 BOYgbO21S0BFaJLH5XeGLEdjWNKTo2dyB1ob4VzLQ7U3v3Q1lf1/DMuRcfZpMQcrWzKm0HdWou4x
	 +JG8Pr30gnJJKnygzlkt+FVEWdGwxJWyu9Fa2MEwXkoSE2rO0pKa0jXy77wcHLnV8+cr4G83bJGt
	 Opf+S1B08M5kU4pDLMcfr7b1K+j41B9pmvU/DJJ04KLH9zyRw0YmHdGfdD6sI0riSz0wpLqYu9f6
	 8wTP4IZiuMBxQYJS7PGFeayPCDAXXn4IZKXZtQFN2RQxDduNnFZ0r71l+30OYMFI/t/xAbDEUTwQ
	 7bOJCnMOW0GRStWNhvlDcq8zXXhsl1W3cRZapET80HUlFlWrgD2PVUemiwnxrC9LAQ2m/fZqptVv
	 QVzcEHKyL+PaBiXCAtpeVMVj+YilSISVmXjIzn8t+Qrih2CR/xUw+Lb3hA1uXfjKvSdVxfe14ZVb
	 Uu4XD0YQkklEE9hVfXJB/YdNh4qc+wY4UvoDFN/aPxnxiXEHdJIPd63V8h8unLVW893FlxXAdVXh
	 GdR1bt1+b7GnLjU943u4mk0Pvz+kcHMQlkG4zB41Q2u34jE+IRY/fimGF4c+Npm0/7AIkh68momw
	 +ZyRLvPxf+LB0fjjqcARM/wZE0gze4jpD8spHj3XkFOPoTAzZX
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v4] net: restore the iterator to its original state when an error occurs
Date: Sun, 14 Dec 2025 10:49:34 +0800
X-OQ-MSGID: <20251214024933.62895-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251213083717.44fb78c4@kernel.org>
References: <20251213083717.44fb78c4@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 13 Dec 2025 08:37:17 +0900, Jakub Kicinski wrote:
> > In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> > and the first one succeeds while the second one fails, it returns a
> > failure but the count in iterator has already been decremented due to
> > the first successful copy. This ultimately affects the local variable
> > rest_len in virtio_transport_send_pkt_info(), causing the remaining
> > count in rest_len to be greater than the actual iterator count. As a
> > result, packet sending operations continue even when the iterator count
> > is zero, which further leads to skb->len being 0 and triggers the warning
> > reported by syzbot [1].
> 
> Please address the feedback from previous revision and when you repost
> use net as the subject tag.
I have added the following explanation in the comments:
Regarding the judgment condition, I aligned it with the condition in
skb_zerocopy_iter_stream().

syzbot reported the issue in the linux-next repository, and I also
tested and created the patch using the linux-next source code repository.
Therefore, I added the subject net-next tag.
If you think adding the net subject tag directly is acceptable, I will
adjust it in the next version of the patch.


