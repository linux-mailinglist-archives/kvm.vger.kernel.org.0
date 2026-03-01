Return-Path: <kvm+bounces-72308-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLaaH/ypo2nfJQUAu9opvQ
	(envelope-from <kvm+bounces-72308-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:52:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F18941CE038
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4240232F7DFB
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009D42E06E6;
	Sun,  1 Mar 2026 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Akhc/Xt2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31705243969;
	Sun,  1 Mar 2026 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329451; cv=none; b=QX78y/74EsY23ghK3vtnP8PQUaDvl5VJ2evRl200473jNgMfkl2XgCYJT+PoruwCT1Nac0Y416zn8xY3lBxstpBBDQslYPxhsGpsWfe5FIC0R8gfnz30/6ykis5OPx8p2t1Vj37j8EeX0qWJAQFo1UhaCZAMTx7AdqWVQYvzDUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329451; c=relaxed/simple;
	bh=ICWJceNjWAcsYgqkB2Ubv4dZDEYGG4zPXXvZXz8Lmxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PxyF8F4pnzeNawYzN7mg4J1p4Y8qZhBcX0OAV7CluZIN3OiLmUwFM4a/WB/2N98EcnV6LEPH9fanHywiqo91urkJcPoWe1JHe72XVNB6zQ4ZO5swztBSrjCizgr0Owre4WFua94kkZQ6b+X82IPuu/Awrdxvs8rW3IZ1Glwf7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Akhc/Xt2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9EAC19421;
	Sun,  1 Mar 2026 01:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329451;
	bh=ICWJceNjWAcsYgqkB2Ubv4dZDEYGG4zPXXvZXz8Lmxc=;
	h=From:To:Cc:Subject:Date:From;
	b=Akhc/Xt2UlLelGxL4GLWZ3Zp8z5owBYfdpO2KuAcD4CMQWr8KjwZaJOM7wK1WKP36
	 BVw7YzgB2UQf/Hz7gOgf/bGuPOSAL3tc3q5EZrU3JFIDcUTPTu1cvcmOmgoDTy9mRb
	 Zpk6rWwD72oVLgNbwpFIIGu0PXaPJ13v2ZebHIeyaDL7vjTvkEGbOhPHMeL8QOGl+/
	 /+f18K15XJjAPuF4XfdZzUJ1Z7m0kXLeFdb0i6H6g2pkxsKkeobhSDEZOs2bTQqzJl
	 JMtCEjMeLRIFoNUC8nPgux0tlZ+sDCJmOXN/KOhJu3QS+41sFnoaW3VflCnFI7Pc+5
	 l3S4q5bQl9QGw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	eperezma@redhat.com
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: FAILED: Patch "vhost: move vdpa group bound check to vhost_vdpa" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:44:08 -0500
Message-ID: <20260301014409.1706293-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72308-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: F18941CE038
X-Rspamd-Action: no action

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From cd025c1e876b4e262e71398236a1550486a73ede Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Date: Mon, 19 Jan 2026 15:32:54 +0100
Subject: [PATCH] vhost: move vdpa group bound check to vhost_vdpa
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove duplication by consolidating these here.  This reduces the
posibility of a parent driver missing them.

While we're at it, fix a bug in vdpa_sim where a valid ASID can be
assigned to a group equal to ngroups, causing an out of bound write.

Cc: stable@vger.kernel.org
Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-2-eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 ---
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 6 ------
 drivers/vhost/vdpa.c              | 2 +-
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index ddaa1366704bb..44062e9d68f00 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3640,9 +3640,6 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	int err = 0;
 
-	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
-		return -EINVAL;
-
 	mvdev->mres.group2asid[group] = asid;
 
 	mutex_lock(&mvdev->mres.lock);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c1c6431950e1b..df9c7ddc5d782 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -606,12 +606,6 @@ static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
 	struct vhost_iotlb *iommu;
 	int i;
 
-	if (group > vdpasim->dev_attr.ngroups)
-		return -EINVAL;
-
-	if (asid >= vdpasim->dev_attr.nas)
-		return -EINVAL;
-
 	iommu = &vdpasim->iommu[asid];
 
 	mutex_lock(&vdpasim->mutex);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385a..9d25b735b43dd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -680,7 +680,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
-		if (s.num >= vdpa->nas)
+		if (idx >= vdpa->ngroups || s.num >= vdpa->nas)
 			return -EINVAL;
 		if (!ops->set_group_asid)
 			return -EOPNOTSUPP;
-- 
2.51.0





