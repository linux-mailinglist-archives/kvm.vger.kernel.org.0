Return-Path: <kvm+bounces-25707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA899693A9
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A25921F244E2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 06:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425F87DA62;
	Tue,  3 Sep 2024 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b="qUH2yqE2"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A41CFEBE
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 06:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725345017; cv=none; b=t7CNvMFsp7EXJYAhC2YqNTi/VaAknR8ehWb2Y3WLOgLa0LXi2B3KAlno46+YH1wAcw+zsJ0u3qCe8wgoFTSwt2mHoTyqsLEUDnqyxwknUebOTTjL38r0xbQJeIey8cu+top+aoNvkAmwRvb6RMIAY5yqhwBaiq8WTsfPZAMBa3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725345017; c=relaxed/simple;
	bh=0s2yGfRnZJjtHsYl2lUMVSDYEemvKJR5jdb0YqL1P7k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZY9Se31Wdp3JO+JWx0+dk0ldadXKynLm5cznmABd5vXM4wJCntLkRU5FlQUlCmP2209jplPLEKKse2zJDQEgdG0/eid9vzRB+080kynv/1gnndR5SSYmI/gvG4BIrYVX2JD3H87RJTuUnEmN0n6pi59lzMGQlXnehA+LqXQ6AyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b=qUH2yqE2; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1725345002; x=1725949802; i=erbse.13@gmx.de;
	bh=vv2avKkp/oIl72L47UeSkMyREe7Sb6GxGrdiZncgkK0=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qUH2yqE2/OVD2gX/A3sGU6DA5Dp+vxWueu6TaMgIkDg5DIPGApGnNqecPs1Cql6Z
	 UjQENjY3SdD4toY/3EOX8Mf0FVdP9NZonU+VcXIK0GcLacD31g7hdLGqeB85X9Cot
	 ZaIwaXqYrMGTeYfi8/O3LYRAUV2JRmgP1Dh0ePhEaceDi78mlRtNVwCvVH2X9Djsb
	 1hBpKjht0yZgan+9E3k1iFcxLKVvFcFDvZNu7fuwMo8RF3Dbhq/4/OGjeWEGPn6b1
	 tOlNazRHVqTMEjQq6xsH7R0l9G+TkiOHDmo0eruMKvBOrWFoIvWt1HYgxncO6sQ4l
	 fw5LnGyKh8aGMKip+w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from server ([109.192.237.113]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MTiTt-1sdy6R10tZ-00SQLD; Tue, 03
 Sep 2024 08:30:02 +0200
From: Tom Dohrmann <erbse.13@gmx.de>
To: Tom Dohrmann <erbse.13@gmx.de>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] accel/kvm: check for KVM_CAP_READONLY_MEM on VM
Date: Tue,  3 Sep 2024 06:29:53 +0000
Message-Id: <20240903062953.3926498-1-erbse.13@gmx.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TeL5Dpd+HeKRcyOCGLFIYa1mmRh2o78bO05fbEbFeB23MUB3yjt
 NrkopVBcHiGVqvL7yqd58jff/wsZL3pzQmklSIikYloVrz48WtCa7KYPTtmibzyktKFUhkZ
 BnmofNtDAG9HXHsXBqm14XjDjbb+VRECNPGrtL/pl1VxbVplSQ7by2SvH4D1MqCia/tMa8Z
 0+rYm2kgGjRTn+a0K9trQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Aoy+/hfHX8s=;PU1rzbY/jH+nOTiOGqaEGQqSIaS
 aIzQ5HHpzr67nIlTmR1OKxf/idtQGgzCeOQ5sL95/KNlS6bEQjJNDh4YIcdl+LItMdlienN29
 Noow4naiPzefqPqTthRDvPoz23RuH/9/PEKeG2bfWxHKj3TUcQKUB8NHJ0tMGJ55MvQNp3W4A
 NiCfHjUSzpz2ncJAzThbzGNy+hMcwiws0WFaZbf3FFasnqF3vtIPwgCPZ/V/6lgZft3B2XwrO
 aMjGGzCSFMpkBvi59+uuceuS8jeNd1BVPgVvb9LUwOCky4aD6r+osYfLRSugeIvKCDaljO1uy
 Bv54LB1g2E6G4Ac8OWbuEMv8mB0noEe/l2oYMlkHHL6xRkv0+HfO8H7o5F4MMlr2n+FAX+2gI
 Hns/tat79rf6TLDsGAIbch2RTKPuzSDGJd9v6F/BneHcoo+IjHVDW4pn9lSEKs+hE70U/xMrR
 nRCdq89I/vUpdSzzyeT9368rQv7tSgeOAwF0yu+we1PNNXNBhZZSS4VCBpmOwNyH+ul6A5CSO
 gSF+YyVFgVUp/UIRlYn9JpEh/zucWo1IQmA+aQtkLyMq5CAAJdfMGzGIblLA0PcmxFjJbo8kj
 xmDZKMtF02W/LDcl+Q3CARkQZkw2i+nf0vBHxN8il601uoRrAjsS+B66ViRFJDi62/xzHin03
 DZlqbL/NmSUUlQYFXTw5deI6pA8ss/nILH2yS+QA6JMxoyfvYVUpoQm4Wdba0BaGbF5+NLRuV
 vESO+WGuYCpLmQENtw53o0jPd67zkBjr4ROri/rOx4UlYtIjECbD2qNwQENrm07YsWDQAmM1+
 l0vbA9vHJv3otZyb2oYhbj86BhwJgdTaDzVCPuoxOnsKM=

KVM_CAP_READONLY_MEM used to be a global capability, but with the
introduction of AMD SEV-SNP confidential VMs, this extension is not
always available on all VM types [1,2].

Query the extension on the VM level instead of on the KVM level.

[1] https://patchwork.kernel.org/project/kvm/patch/20240809190319.1710470-=
2-seanjc@google.com/
[2] https://patchwork.kernel.org/project/kvm/patch/20240902144219.3716974-=
1-erbse.13@gmx.de/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
=2D--
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..acc23092e7 100644
=2D-- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2603,7 +2603,7 @@ static int kvm_init(MachineState *ms)
     }

     kvm_readonly_mem_allowed =3D
-        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
+        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);

     kvm_resamplefds_allowed =3D
         (kvm_check_extension(s, KVM_CAP_IRQFD_RESAMPLE) > 0);
=2D-
2.34.1


