Return-Path: <kvm+bounces-49459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B24CAD92F4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DCC81E076E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CAB20E717;
	Fri, 13 Jun 2025 16:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sean.taipei header.i=@sean.taipei header.b="1Wof1JWR"
X-Original-To: kvm@vger.kernel.org
Received: from sean.taipei (mail.sean.taipei [128.199.207.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848A52E11B5
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.199.207.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749832851; cv=none; b=OBKdWPy89PM4hQV1s2Aln9JX5THlUa6QPa1bydwFIjiMLca2g+/IcvMUPB9bEcLva/a7zmXbuGO+rIBWScY1j7t/UlWAphW+fegq0alFB4Fy86c5eVPAj5BM2hY5qXNExi2pZkWWrgUDjJ8ITvVfMWQI0G61oMNsH056csnbmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749832851; c=relaxed/simple;
	bh=w9Yu4hxd5YkZTczKQMfEZj+pbo8vVb2woEIq4gGi6j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpBFRROUCIs5H8yzRSrUeBsO78L01+N4ZSK2nlCR+cwMHOpqrVBMISoLdJZM/bwxgaCRzMvK8YxESJB9p5T6EUVmmvCCWgsTd9oyoWIi7AFNRkiztR/tiH6JPWkL/gLvnKj8qYCyjqGpV5+T+Mmt8pP1GilIaiALbuaWfQP5/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sean.taipei; spf=pass smtp.mailfrom=sean.taipei; dkim=pass (2048-bit key) header.d=sean.taipei header.i=@sean.taipei header.b=1Wof1JWR; arc=none smtp.client-ip=128.199.207.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sean.taipei
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sean.taipei
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sean.taipei;
	s=2021Q3; t=1749832752;
	bh=w9Yu4hxd5YkZTczKQMfEZj+pbo8vVb2woEIq4gGi6j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Wof1JWRGWjAKc/k0msM7mx/gYCYnHzg4PId9jLI7kEaRmRBGdkD29mH5yeVaZZAX
	 CaNyGBcJIE9ftbPg12dlFZjHoCQKXCMZRVMpzuvLtDr7Zqlce7EiOtSWD686ldT7iZ
	 twe8JIY/sWhYoWAW2XzSW2CIqJAUQ0redAkIXikzyEoavjaj4PmT4PquxIALQYQsim
	 kp3LhYlUW/WfuvTY5xf54uxuaRwCytI5buJtZCnhJvh8pMOlYiVG7t42FbyF2hXpKA
	 7aqlUHVdYIOsjNV4n/znLsmvPcslnlNglD4sUjUlESdWsMHmApXSTgWTxvw8DzVlys
	 OQezUDnJr+WuQ==
Received: from localhost.localdomain (unknown [72.14.99.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by sean.taipei (Postfix) with ESMTPSA id 0DD0354F1;
	Sat, 14 Jun 2025 00:39:08 +0800 (CST)
From: Sean Wei <me@sean.taipei>
To: qemu-devel@nongnu.org
Cc: Sean Wei <me@sean.taipei>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH 02/12] linux-headers: replace FSF postal address with licenses URL
Date: Fri, 13 Jun 2025 12:38:48 -0400
Message-ID: <20250613.qemu.patch.02@sean.taipei>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613.qemu.patch@sean.taipei>
References: <20250613.qemu.patch@sean.taipei>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GPLv2 boiler-plate in asm-arm/kvm.h and asm-powerpc/kvm.h still
contained the obsolete "51 Franklin Street" postal address.

Replace it with the canonical GNU licenses URL recommended by the FSF:
https://www.gnu.org/licenses/

Signed-off-by: Sean Wei <me@sean.taipei>
---
 linux-headers/asm-arm/kvm.h     | 4 ++--
 linux-headers/asm-powerpc/kvm.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index 0db5644e27..a8bb1aa42a 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -13,8 +13,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * along with this program; if not, see
+ * <https://www.gnu.org/licenses/>.
  */
 
 #ifndef __ARM_KVM_H__
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index eaeda00178..83faa7fae3 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -10,8 +10,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * along with this program; if not, see
+ * <https://www.gnu.org/licenses/>.
  *
  * Copyright IBM Corp. 2007
  *
-- 
2.49.0


