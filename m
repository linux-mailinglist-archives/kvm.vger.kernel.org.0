Return-Path: <kvm+bounces-60775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB227BF9619
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A931E19C23E4
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0384E2FCC0D;
	Tue, 21 Oct 2025 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+gt5wjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901A2EF65A
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090441; cv=none; b=qT40alSRTFwkxjOkat4EPZDchT7uH267zGM8JeHHSaJXwDaPHuMfAG2v/AxtDSq9gfboqJlW1aPYbUHSdlh/yhNvZjnqRAJhPXUHb0GrCRQr3IZpXy7rvVodLEufgEdC/i8bjyyQOTQc3605gZwl7CFgO36WLc4J857K/S10ugU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090441; c=relaxed/simple;
	bh=MF/czfrq9R+gzUXq3nakRInrzOwnmvgXgQyREpFMOsQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HsKlfQVvMvSn1J8CNx0l5z28VhOdqan4aw/aGZ5Rak44Si4ADryiUnMc1wU933iOE0keB4q60vha/cCvV+5p4Rel/tJKjy7/XvUhZZALbJlmpQtCrsphQ9Skzf8uzho0qP05uCaKsq8vpWOJrtaQi91KKBeBDkt/HtSH4YRZfv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+gt5wjc; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33be037cf73so4836427a91.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090435; x=1761695235; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D6mUZMq9SVTZCVxtIiXitg02c6DGfDqdmAO69aX2eA4=;
        b=Q+gt5wjcUAWtZ1+Pa+QKWygd7P0u+N4yhjAijbU6jC2CCxufGapnDsR1Ijcr3Oi3SD
         ojh9jDqGB0Xnt1ExxkM7bqyKm9mi+xF830Wz1EgVDCSL/rsy/RoTL0qnEis2Y8ls1rO/
         pmqxqOPscZTQEs7Z942VDGmhNBd7iw2TDBokfXWzl2kPtB1n9Es0dK2F/TxAZj72N2e+
         68M+2YfrBnwaKrYKxcwcrHHhkg9gnxyf+9GvkRuJRAoXYObbpqbFd44a3bGVhfVsfsTe
         AaOiI5dmeI2ucyLa0eKl9kyned47owzg3NkYy1ZHB+n3PvC0Jdy2kd/kuntVANcluzAy
         udrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090435; x=1761695235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D6mUZMq9SVTZCVxtIiXitg02c6DGfDqdmAO69aX2eA4=;
        b=qKB0tqRHCGIYG5B8GkefkvKoqLW9ElNVzShdlqy9dS3n8bYM3fTb7stHHhOvhw9DOm
         cKurJzL+E1X4NvWJZyDZgrbgwXSdGADSI12Wp0V5GC9TiDX/IqveNlH55FowF0Ytc0HN
         VfAyBeyQBmjvzlcNp7KhiYuIjhNlhed+qMSshj5kNhT989SL5y8rEbNGlXVMEPfVcI6p
         Yvl5m2fos/Rddf/utFKxUmX9NZt4P+02E2TirIrs+AIiu50qI7X9UtND61KgI2U5sb8j
         Wxy38Y2ul9+zorVqCGS8T8fqlJPz5jmnTVXktlpskbyxYwz75Em/o/gzAh+l+VHt2UNg
         GPFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVypG5hQ9cJ1LrgelnAygEQmsf7SOHU36siOQgWBbhgsQgOVa7vYDtjsRj1ZE2UUfNjBU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzb1TVcpMINoGFXExWpUqI0YJT4NsRhla8f7RbtZN4rTZ6oLmu
	qQgYQQaG3DoxhCa5WeHb9/8OdnimPeztt08apLzwlITiKwyal4FAdfdx
X-Gm-Gg: ASbGncvLL1ziaF6UXZjlxm2xCo3U3ogidjtjDFHSYxVzUGiFrseOaUUR3dRGO/wsAMz
	meLgsehwfh/HIl5RrD6OknVX0AUG39tK8BwuxJtcJiU2HzU2/o65GL5ws7g3ZkHpozQVeHAA4iP
	0dv3t7CZ+0C3lxvZh6i8jXpgYYhqN8S4AAdHf8+j7PgfkNnlCUgjseKZ9nXYdrdArUuyB6yS0zR
	4djUXHYb+snEHajHRzA0OGqLmjPdFTdX2iFU2X06DP/sK91OhvPFjjsD4p2w5y6ieZhrzNh4alK
	1LsAiVNmDbkNAkDsvhdYBn6E0IMzsJKVt9XFuIrUnhkxbipkl2w2BxYqrv/C6hlXfxYJap2q1jB
	zqhCZbpA+3MsjBIUX/lhxA9Y5LWk62zO/fjakywKvIvF/fL+3seBHI5dNZCkkWxdtWOjMGjTS
X-Google-Smtp-Source: AGHT+IFVbMkOuOiBDnCJEvlMwLaZ7DlmhKs/V/NW1acHbQ/gNGtWZNBni32L0tz8fkkeIan2KaLV9w==
X-Received: by 2002:a17:90a:d60f:b0:32e:d600:4fdb with SMTP id 98e67ed59e1d1-33bcf8e61b8mr21858888a91.18.1761090435179;
        Tue, 21 Oct 2025 16:47:15 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e223e223esm711430a91.7.2025.10.21.16.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:14 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:47:00 -0700
Subject: [PATCH net-next v7 17/26] selftests/vsock: remove namespaces in
 cleanup()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-17-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Remove the namespaces upon exiting the program in cleanup().  This is
unlikely to be needed for a healthy run, but it is useful for tests that
are manually killed mid-test. In that case, this patch prevents the
subsequent test run from finding stale namespaces with
already-write-once-locked vsock ns modes.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/vmtest.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vsock/vmtest.sh b/tools/testing/selftests/vsock/vmtest.sh
index 914d7c873ad9..49b3dd78efad 100755
--- a/tools/testing/selftests/vsock/vmtest.sh
+++ b/tools/testing/selftests/vsock/vmtest.sh
@@ -145,6 +145,9 @@ vm_ssh() {
 	return $?
 }
 
+cleanup() {
+	del_namespaces
+}
 
 check_args() {
 	local found

-- 
2.47.3


