Return-Path: <kvm+bounces-66738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 545D1CE591E
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A3EF3006A86
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AAE2E0904;
	Sun, 28 Dec 2025 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="TA6dNCEY"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster4-host4-snip4-10.eps.apple.com [57.103.65.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3A11E32A2
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.65.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966205; cv=none; b=BvQDo7Yi16d52cEp4AjPZrUK0ozSPGtUH7IK3M4x9ry4M5M5IhnikFEhBTY/oIl1yPuYRirTN/pvucdHmwAgfT9Q0QJ4jzqaH1TWGgkz5jz6ZPwtY0N1oMu8S0/MSU2iQ3tH+XV0Pw97HCpBoGnEwrJdCfA4/Ro84Xt/2pgp8mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966205; c=relaxed/simple;
	bh=vzl2b/xiCls1qE8iN15//zpDp2M8JQSGEEsxn2apHnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIf49QzQT79RbQ1/wuWEvMnVPvaZ4X1fD2HSunvgOZcjmkoz6DZws8ODGc3rc2pLVt2Ue2WWwJIB4ZSfHQvprfSbFicb4e/b6tgLT9Jw1MkjysWpFIGj+b7MN2EDyDQTjMWtV7N7e9owViG6P6XtTFmMX/IF5q6PagYwEQNSu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=TA6dNCEY; arc=none smtp.client-ip=57.103.65.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 827461800744;
	Sun, 28 Dec 2025 23:56:40 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=9dZ0bIRQfVZYIGGuhzKfcBpJ5dwbdg2lwsrZICRf3mY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=TA6dNCEYGCcH0VOu8eJBSrw8c8EO+WqT96BfmHI7Cv3vIsu3zR5xDilA3+tEbrPDuKlcAOSUx19hzA6kjpzZIP+ZHMFKTnUJdGL8XW5nO9KLzVyOQauuW/gZdjMHHx2ZtNoGvwEiQ+iEXOP/wvc70ib7RTEysxCowUIaBiAeVoYDXYtI4qhHThvskXcLXWrRuXHi9IudpCr+g9x+4ruWPJk4v8g7oVeqyPdIVqh8Xwr3MlMhg+ioz+TnujLhuPAd5BxAsYqlvoYEkKaGNwsDOEZQXZEkMh1V/Mcv0nJRHEcZUidzI9EBJvB6nHuZiEASukCEuh0yu9ynDSIB8ux6jQ==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id BC0E2180074E;
	Sun, 28 Dec 2025 23:56:33 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org,
	mohamed@unpredictable.fr
Cc: Alexander Graf <agraf@csgraf.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	qemu-arm@nongnu.org,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v12 09/28] docs: arm: update virt machine model description
Date: Mon, 29 Dec 2025 00:54:03 +0100
Message-ID: <20251228235422.30383-10-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info: v=2.4 cv=YYKwJgRf c=1 sm=1 tr=0 ts=6951c3ba cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=UWX6RoDBcPCHCN3xbnsA:9
X-Proofpoint-GUID: EtxjQywVbxc3nE96Rj7CmIafWux5kYLL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfXzjNmEipZwqVg
 PMgPx/XF4NwWggXrLdc74Aksqyxjloxll6KJZpSnquRXmhfKO6Iv3s0meQvURoXGxSHxry4dorU
 G3YBkzqt3mVXhqhYdwGZGeeZRGNyj22XGvOIq/u656bMBb6H0HHZTgs4mvgCXJZiDyp0qeeCyvW
 JKpKAxs+MowLyKFqkwRQhPHTkPe/qDtWA2uiuUi4OmlwMlFq+7ZaznIZ2e70V9Ub0n4fpN0HaSi
 oOf/iRtxTNl9AJls9SevXyA0ycPYfCV5qCdvXU0gpwHVRlVHGIS0r6qY1zX5PIVPYj8H+eK5gdw
 4AZkcarplqMZvLZKjLc
X-Proofpoint-ORIG-GUID: EtxjQywVbxc3nE96Rj7CmIafWux5kYLL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1030
 adultscore=0 spamscore=0 mlxscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAABMrBUqk1HogRBIFKO7KFoGZLlIHnJ5goFC0HZDvLyIENksuNF9H2PPzdO4GJKku4Z249JQLpF5fwdymciuYHxwYosuKHy9fc8NE9QT3518ppMPZfCfn59t0wiywj+F9wv0ju6jAmQjYk0TXoE+HoahNFz16JCakWGFq+rbEMLnEKYviOkpcm2eOomtcEb7n07aZowZ6Ggo3mpi81XJ3f3CE3DzeGtKRxYMyw2upnQn428P83vNvfKRt9794x6aERlOVEKouzdGF49M1lZQUEKDM5PIDx9PKcSXmUtBeaVEwadGPXUtVqZgTw6nSkYNZDTnnGH4MLy1jWssewrB2EvgNAfcHPpkuq/lWq4yJ7+xZgTAPaiP7k24GG+iqgbq7nSlrCklxmkoSZGp9wbZn08MWwkgG1vRJ/oMsSHNOcLrb0V78VQhNVJwyOj2A2WfubZx/aIkCWXEOU0SF7Ri7XpwLGB/BqZiPTni/Mc75tHgm7qOqGIcnt7956dwfSD0bfw+NqeiZVOLJpDdFoNrwlMjwSI4pXmCRRjuvxwdxuwiDr0WIPiqcoGo3Hy6kaJEkP6oEFqYWETucnO52/5d+ZciP86Ag2NqaDomMP06vWbozWXpJOjbV+kC8Ovsq9olujP9o4IGIKw3PVZoTN1rqmO/FRqQy2US3CMrbx6zG4AWCoUAhbNbpXVaWkRXAwXWPUTuUGygB8KTiAUXlO/zgwtW6Ve3HcyBMaUfM+pWypi4u4Jgl8KMSi7SHPIkEc4iHTLfKPbJE3o07WlQxssn/X/ADKulcMRZquuslcMKKB2vU1LeCyRVWih0oop2Bmjbj5xOHMP8jECSg1i+6r8aVpsy8U61x1jhMCVhnhpI2KBSTXF/cKJZ/54TWtozQWCD61+PvGkTUw6efH2q/jKllZceT9zPiVPyPeJmWMCjif8/iq6ne7YGfTeyIHRA7V0N/g9cKsFDSBT

Update the documentation to match current QEMU.

Remove the mention of pre-2.7 machine models as those aren't provided
anymore.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 docs/system/arm/virt.rst | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
index e5570773ba..b6e88c4f13 100644
--- a/docs/system/arm/virt.rst
+++ b/docs/system/arm/virt.rst
@@ -41,9 +41,10 @@ The virt board supports:
 - User-creatable SMMUv3 devices (see below for example)
 - hotpluggable DIMMs
 - hotpluggable NVDIMMs
-- An MSI controller (GICv2M or ITS). GICv2M is selected by default along
-  with GICv2. ITS is selected by default with GICv3 (>= virt-2.7). Note
-  that ITS is not modeled in TCG mode.
+- An MSI controller (GICv2m or ITS).
+  - When using a GICv3, ITS is selected by default when available on the platform.
+  - If using a GICv2 or when ITS is not available or disabled, a GICv2m is provided by default instead.
+  - Before virt-11.0, when using a GICv3 without the ITS, a GICv2m is not provided.
 - 32 virtio-mmio transport devices
 - running guests using the KVM accelerator on aarch64 hardware
 - large amounts of RAM (at least 255GB, and more if using highmem)
@@ -167,9 +168,11 @@ gic-version
     with TCG this is currently ``3`` if ``virtualization`` is ``off`` and
     ``4`` if ``virtualization`` is ``on``, but this may change in future)
 
+msi
+  Set ``auto``/``gicv2m``/``its``/``none`` to control MSI controller configuration. The default is ``auto``.
+
 its
-  Set ``on``/``off`` to enable/disable ITS instantiation. The default is ``on``
-  for machine types later than ``virt-2.7``.
+  Set ``on``/``off``/``auto`` to control ITS instantiation. The default is ``auto``.
 
 iommu
   Set the IOMMU type to create for the guest. Valid values are:
-- 
2.50.1 (Apple Git-155)


