Return-Path: <kvm+bounces-72334-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AaHN/XupGlpwAUAu9opvQ
	(envelope-from <kvm+bounces-72334-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 02:59:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3031D2633
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 02:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCB9330179ED
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 01:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF457283FC4;
	Mon,  2 Mar 2026 01:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunyoo-cc.20200929.dkim.larksuite.com header.i=@yunyoo-cc.20200929.dkim.larksuite.com header.b="oI3Hh2kl"
X-Original-To: kvm@vger.kernel.org
Received: from lf-1-16.ptr.blmpb.com (lf-1-16.ptr.blmpb.com [103.149.242.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF64288D6
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 01:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772416728; cv=none; b=fh1TxBbRA8/Z/cl72c8Vj4wkm0GlKCQxqYcYKqzqJTaHD491Gxz8bGyC1n8rCyXalYdoz6cEYd72s4UX4xiguuVUSPVR1JLnuCypzk7dIHcbbB05QiRvj6UxLCZRxKpvmuLMInsRUrP2B9r055eCXoDq/8VfxaobYNpltkH4+wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772416728; c=relaxed/simple;
	bh=Adqf0zh2hayDMj7FF1I0bgPXD9fxuN4yMCe2P+dI7vg=;
	h=References:Content-Type:To:Cc:Subject:From:Mime-Version:Date:
	 Message-Id:In-Reply-To; b=KPMcoBvFV+wc9xknEUX8gKR48xw2q4Q4Yz1DV/p0g/VgY9OcUWMD4RQFXIhvJEhiPZKXhUk4Q8XpARBFzeI1yz4jSHRJrBqCTlOWMo6jOm1jYfGSiTi1xDvRdYfMy5ESchGdK65eoYzoG4Olo3fuNROS0hfM5ObW585cZGYZrP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunyoo.cc; spf=pass smtp.mailfrom=yunyoo.cc; dkim=pass (2048-bit key) header.d=yunyoo-cc.20200929.dkim.larksuite.com header.i=@yunyoo-cc.20200929.dkim.larksuite.com header.b=oI3Hh2kl; arc=none smtp.client-ip=103.149.242.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunyoo.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunyoo.cc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=yunyoo-cc.20200929.dkim.larksuite.com; t=1772416673;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Adqf0zh2hayDMj7FF1I0bgPXD9fxuN4yMCe2P+dI7vg=;
 b=oI3Hh2klncXn9VySxG53E47EvKfmKXi9QnSgDZHHPb5WzOPD1vg4yPWwsfGHF5AQGo/YAY
 MiFugChHTtB5rqzURRdMydjiLAtCe47Y/BlQ4O6nXTMw7auoRS1MbJH90UWaVRHFSReFry
 xTzHl8VgLR8Bs8plZSViFJnbQCgOQqjamL2CJdUKYHI3C/8nNJmye1xK0CEwAqYexKlyKn
 iLXUp8bE1i4jLQrmJP9JCDlUysHXP6mOe7aGon5SK2E5vV7ICDIDWLmiq4zMrFLM47mEBD
 KeIEFCgm5nZcJvE3ZAUFKvu8MWJE/97MFvOu9/PzkKZ//Dki1eo77tGUDQ4S4A==
References: <9ac0a071e79e9da8128523ddeba19085f4f8c9aa.decbd9ef.1293.41c3.bf27.48cdc12b9ce6@larksuite.com> <20260301190906-mutt-send-email-mst@kernel.org> <20260301193655-mutt-send-email-mst@kernel.org>
	<20260301194456-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [BUG] vhost_net: livelock in handle_rx() when GRO packet exceeds virtqueue capacity
From: "ShuangYu" <shuangyu@yunyoo.cc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Mon, 02 Mar 2026 01:57:51 +0000
Message-Id: <9ac0a071e79e9da8128523ddeba19085f4f8c9aa.8ae4e890.449b.4397.8e81.d58ff010ba07@larksuite.com>
In-Reply-To: <20260301194456-mutt-send-email-mst@kernel.org>
X-Lms-Return-Path: <lba+169a4eea0+db670e+vger.kernel.org+shuangyu@yunyoo.cc>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[yunyoo-cc.20200929.dkim.larksuite.com:s=s1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DMARC_NA(0.00)[yunyoo.cc];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72334-lists,kvm=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shuangyu@yunyoo.cc,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[yunyoo-cc.20200929.dkim.larksuite.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yunyoo-cc.20200929.dkim.larksuite.com:dkim,linux.dev:email,larksuite.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3F3031D2633
X-Rspamd-Action: no action


> From: "Michael S. Tsirkin"<mst@redhat.com>
> Date:=C2=A0 Mon, Mar 2, 2026, 08:45
> Subject:=C2=A0 Re: [BUG] vhost_net: livelock in handle_rx() when GRO pack=
et exceeds virtqueue capacity
> To: "ShuangYu"<shuangyu@yunyoo.cc>
> Cc: "jasowang@redhat.com"<jasowang@redhat.com>, "virtualization@lists.lin=
ux.dev"<virtualization@lists.linux.dev>, "netdev@vger.kernel.org"<netdev@vg=
er.kernel.org>, "linux-kernel@vger.kernel.org"<linux-kernel@vger.kernel.org=
>, "kvm@vger.kernel.org"<kvm@vger.kernel.org>
> On Sun, Mar 01, 2026 at 07:39:30PM -0500, Michael S. Tsirkin wrote:
> > On Sun, Mar 01, 2026 at 07:10:06PM -0500, Michael S. Tsirkin wrote:
> > > On Sun, Mar 01, 2026 at 10:36:39PM +0000, ShuangYu wrote:
> > > > Hi,
> > > >=C2=A0
> > > > We have hit a severe livelock in vhost_net on 6.18.x. The vhost
> > > > kernel thread spins at 100% CPU indefinitely in handle_rx(), and
> > > > QEMU becomes unkillable (stuck in D state).
> > > > [This is a text/plain messages]
> > > >=C2=A0
> > > > Environment
> > > > -----------
> > > > =C2=A0 Kernel:=C2=A0 6.18.10-1.el8.elrepo.x86_64
> > > > =C2=A0 QEMU: =C2=A0=C2=A0 7.2.19
> > > > =C2=A0 Virtio:=C2=A0 VIRTIO_F_IN_ORDER is negotiated
> > > > =C2=A0 Backend: vhost (kernel)
> > > >=C2=A0
> > > > Symptoms
> > > > --------
> > > > =C2=A0 - vhost-<pid> kernel thread at 100% CPU (R state, never yiel=
ds)
> > > > =C2=A0 - QEMU stuck in D state at vhost_dev_flush() after receiving=
 SIGTERM
> > > > =C2=A0 - kill -9 has no effect on the QEMU process
> > > > =C2=A0 - libvirt management plane deadlocks ("cannot acquire state =
change lock")
> > > >=C2=A0
> > > > Root Cause
> > > > ----------
> > > > The livelock is triggered when a GRO-merged packet on the host TAP
> > > > interface (e.g., ~60KB) exceeds the remaining free capacity of the
> > > > guest's RX virtqueue (e.g., ~40KB of available buffers).
> > > >=C2=A0
> > > > The loop in handle_rx() (drivers/vhost/net.c) proceeds as follows:
> > > >=C2=A0
> > > > =C2=A0 1. get_rx_bufs() calls vhost_get_vq_desc_n() to fetch descri=
ptors.
> > > > =C2=A0=C2=A0=C2=A0 It advances vq->last_avail_idx and vq->next_avai=
l_head as it
> > > > =C2=A0=C2=A0=C2=A0 consumes buffers, but runs out before satisfying=
 datalen.
> > > >=C2=A0
> > > > =C2=A0 2. get_rx_bufs() jumps to err: and calls
> > > > =C2=A0=C2=A0=C2=A0 vhost_discard_vq_desc(vq, headcount, n), which r=
olls back
> > > > =C2=A0=C2=A0=C2=A0 vq->last_avail_idx and vq->next_avail_head.
> > > >=C2=A0
> > > > =C2=A0=C2=A0=C2=A0 Critically, vq->avail_idx (the cached copy of th=
e guest's
> > > > =C2=A0=C2=A0=C2=A0 avail->idx) is NOT rolled back. This is correct =
behavior in
> > > > =C2=A0=C2=A0=C2=A0 isolation, but creates a persistent mismatch:
> > > >=C2=A0
> > > > =C2=A0=C2=A0 =C2=A0=C2=A0 vq->avail_idx =C2=A0 =C2=A0=C2=A0 =3D 108=
=C2=A0 (cached, unchanged)
> > > > =C2=A0=C2=A0 =C2=A0=C2=A0 vq->last_avail_idx =3D 104=C2=A0 (rolled =
back)
> > > >=C2=A0
> > > > =C2=A0 3. handle_rx() sees headcount =3D=3D 0 and calls vhost_enabl=
e_notify().
> > > > =C2=A0=C2=A0=C2=A0 Inside, vhost_get_avail_idx() finds:
> > > >=C2=A0
> > > > =C2=A0=C2=A0 =C2=A0=C2=A0 vq->avail_idx (108) !=3D vq->last_avail_i=
dx (104)
> > > >=C2=A0
> > > > =C2=A0=C2=A0=C2=A0 It returns 1 (true), indicating "new buffers ava=
ilable."
> > > > =C2=A0=C2=A0=C2=A0 But these are the SAME buffers that were just di=
scarded.
> > > >=C2=A0
> > > > =C2=A0 4. handle_rx() hits `continue`, restarting the loop.
> > > >=C2=A0
> > > > =C2=A0 5. In the next iteration, vhost_get_vq_desc_n() checks:
> > > >=C2=A0
> > > > =C2=A0=C2=A0 =C2=A0=C2=A0 if (vq->avail_idx =3D=3D vq->last_avail_i=
dx)
> > > >=C2=A0
> > > > =C2=A0=C2=A0=C2=A0 This is FALSE (108 !=3D 104), so it skips re-rea=
ding the guest's
> > > > =C2=A0=C2=A0=C2=A0 actual avail->idx and directly fetches the same =
descriptors.
> > > >=C2=A0
> > > > =C2=A0 6. The exact same sequence repeats: fetch -> too small -> di=
scard
> > > > =C2=A0=C2=A0=C2=A0 -> rollback -> "new buffers!" -> continue. Indef=
initely.
> > > >=C2=A0
> > > > This appears to be a regression introduced by the VIRTIO_F_IN_ORDER
> > > > support, which added vhost_get_vq_desc_n() with the cached avail_id=
x
> > > > short-circuit check, and the two-argument vhost_discard_vq_desc()
> > > > with next_avail_head rollback. The mismatch between the rollback
> > > > scope (last_avail_idx, next_avail_head) and the check scope
> > > > (avail_idx vs last_avail_idx) was not present before this change.
> > > >=C2=A0
> > > > bpftrace Evidence
> > > > -----------------
> > > > During the 100% CPU lockup, we traced:
> > > >=C2=A0
> > > > =C2=A0 @get_rx_ret[0]: =C2=A0 =C2=A0=C2=A0 4468052 =C2=A0 // get_rx=
_bufs() returns 0 every time
> > > > =C2=A0 @peek_ret[60366]: =C2=A0=C2=A0 4385533 =C2=A0 // same 60KB p=
acket seen every iteration
> > > > =C2=A0 @sock_err[recvmsg]: =C2=A0 =C2=A0 =C2=A0=C2=A0 0 =C2=A0 // t=
un_recvmsg() is never reached
> > > >=C2=A0
> > > > vhost_get_vq_desc_n() was observed iterating over the exact same 11
> > > > descriptor addresses millions of times per second.
> > > >=C2=A0
> > > > Workaround
> > > > ----------
> > > > Either of the following avoids the livelock:
> > > >=C2=A0
> > > > =C2=A0 - Disable GRO/GSO on the TAP interface:
> > > > =C2=A0=C2=A0 =C2=A0 ethtool -K <tap> gro off gso off
> > > >=C2=A0
> > > > =C2=A0 - Switch from kernel vhost to userspace QEMU backend:
> > > > =C2=A0=C2=A0 =C2=A0 <driver name=3D'qemu'/> in libvirt XML
> > > >=C2=A0
> > > > Bisect
> > > > ------
> > > > We have not yet completed a full git bisect, but the issue does not
> > > > occur on 6.17.x kernels which lack the VIRTIO_F_IN_ORDER vhost
> > > > support. We will follow up with a Fixes: tag if we can identify the
> > > > exact commit.
> > > >=C2=A0
> > > > Suggested Fix Direction
> > > > -----------------------
> > > > In handle_rx(), when get_rx_bufs() returns 0 (headcount =3D=3D 0) d=
ue to
> > > > insufficient buffers (not because the queue is truly empty), the co=
de
> > > > should break out of the loop rather than relying on
> > > > vhost_enable_notify() to make that determination. For example, when
> > > > get_rx_bufs() returns r =3D=3D 0 with datalen still > 0, this indic=
ates a
> > > > "packet too large" condition, not a "queue empty" condition, and
> > > > should be handled differently.
> > > >=C2=A0
> > > > Thanks,
> > > > ShuangYu
> > >=C2=A0
> > > Hmm. On a hunch, does the following help? completely untested,
> > > it is night here, sorry.
> > >=C2=A0
> > >=C2=A0
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 2f2c45d20883..aafae15d5156 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -1522,6 +1522,7 @@ static void vhost_dev_unlock_vqs(struct vhost_d=
ev *d)
> > > =C2=A0static inline int vhost_get_avail_idx(struct vhost_virtqueue *v=
q)
> > > =C2=A0{
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__virtio16 idx;
> > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 avail_idx;
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int r;
> > > =C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D vhost_get_avail(vq, idx, &vq-=
>avail->idx);
> > > @@ -1532,17 +1533,19 @@ static inline int vhost_get_avail_idx(struct =
vhost_virtqueue *vq)
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > > =C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Check it isn't doing very strang=
e thing with available indexes */
> > > - =C2=A0 =C2=A0 =C2=A0 =C2=A0vq->avail_idx =3D vhost16_to_cpu(vq, idx=
);
> > > - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely((u16)(vq->avail_idx - vq->l=
ast_avail_idx) > vq->num)) {
> > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0avail_idx =3D vhost16_to_cpu(vq, idx);
> > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely((u16)(avail_idx - vq->last_=
avail_idx) > vq->num)) {
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vq_err(=
vq, "Invalid available index change from %u to %u",
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 vq->last_avail_idx, vq->avail_idx);
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return =
-EINVAL;
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > > =C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* We're done if there is nothing n=
ew */
> > > - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vq->avail_idx =3D=3D vq->last_avail_=
idx)
> > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (avail_idx =3D=3D vq->avail_idx)
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return =
0;
> > > =C2=A0
> > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0vq->avail_idx =3D=3D avail_idx;
> > > +
> >=C2=A0
> > meaning=C2=A0
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 vq->avail_idx =3D avail_idx;=C2=A0
> > of course
> >=C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * We updated vq->avail_idx so we n=
eed a memory barrier between
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * the index read above and the cal=
ler reading avail ring entries.
>=C2=A0
>=C2=A0
> and the change this is fixing was done in d3bb267bbdcba199568f1325743d9d5=
01dea0560
>=C2=A0
> --=C2=A0
> MST
>=C2=A0

Thank you for the quick fix and for identifying the root commit.

I've reviewed the patch and I believe the logic is correct =E2=80=94 changi=
ng
the "nothing new" check in vhost_get_avail_idx() from comparing
against vq->last_avail_idx to comparing against the cached
vq->avail_idx makes it immune to the rollback done by
vhost_discard_vq_desc(), which is exactly what breaks the loop.

One minor nit: the vq_err message on the sanity check path still
references vq->avail_idx before it has been updated:

=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0 vq_err(vq, "Invalid available index change=
 from %u to %u",
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 vq->last_avail_idx, vq->a=
vail_idx);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 vq->last_avail_idx, avail=
_idx);


Since this issue was found in production, I need some time to prepare a tes=
t setup to verify the patch

Thanks,
ShuangYu

