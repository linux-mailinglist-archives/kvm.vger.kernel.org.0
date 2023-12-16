Return-Path: <kvm+bounces-4610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CF5581596B
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1A1E1F23376
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423DC2EB13;
	Sat, 16 Dec 2023 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXhW4Hjy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399792E65C
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-35fa12d0c29so1799175ab.3
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734211; x=1703339011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wj0Mut5HzH8zVLvul2P8fFuIwv0JpWCZjoItb4hgRRc=;
        b=gXhW4HjyGIG6lvw6K8kkIL28Zg9VQybQkFVZ6ii7Ylo4zBGslNwBoUVYpvepWSFYB1
         eHFAUP7HmuKvmKZ04PuWepSCqasNGKdJJhpmZvqrK64XUq0sJVvI9VtOHT6c1cO8gj2g
         huNZv64LKtg1sQuVG6Ag7JarhCCTCSRszqT/qWuUGMsKp7vH/UaLsWDYEh3j3DmWC4rv
         I46/s2HbOC4AEwxI/m8VDCONIkb1RVxy95Z2g3GCUYcoWzFiJ1aF1rbC7qJh092vY0GQ
         tkBNvyZgqZ4dVFJ1pj9O12GdY7yKoQ7Ns6qpFjIxEU9lobQBNmhyuv6VNREa8Q6WZ0T+
         Vfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734211; x=1703339011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wj0Mut5HzH8zVLvul2P8fFuIwv0JpWCZjoItb4hgRRc=;
        b=C1JXTIvW/uzShlsjSYYuuKwa/SJ1mpkMbHLT2NoN4QRCVibuuqrRq/QPnhHZt52Vl2
         g+KdNad0TJcpXFv0x7uKBs/cTAvG5DnsFFw8U1SEZ8r4vi3jwoXkp37L61K+UpoKUDcF
         Rr05itqD1KO89L25KroHsSj8OXRCnR7loi/n3u4QNP2W50+MA2f7BtGmhNFj7VMXU+AY
         qIZ/HoBsakU+Z2JZ4df8lvbBYDU9RzTW5wkMBH3+jwwI47+/yIeObCG9XYdQFmJ6zEc4
         p0lpYms4a3S/rrn3MVpM1XZ4vwT8U7hMl838HwsBZ6KptY7oGtu8Pm81A4Xicz42l7m9
         MH8A==
X-Gm-Message-State: AOJu0YyORm5DTILJRTkOxnrtJjUKgIvXlZrHs1xjjGOHuRoWul01tFeW
	OYFctZ3AY2inTRKk8Sn+EuLMCA7SWVE=
X-Google-Smtp-Source: AGHT+IHYh1+XYxyEnHjWdIM84spbdWJPQ3KCBdFOxFPfV06aBtENyzhLMMNQqIFziZJUqBKvpUzksg==
X-Received: by 2002:a05:6e02:1c8b:b0:35f:8102:aaa with SMTP id w11-20020a056e021c8b00b0035f81020aaamr6863917ill.59.1702734210761;
        Sat, 16 Dec 2023 05:43:30 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:43:30 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 03/29] migration: use a more robust way to wait for background job
Date: Sat, 16 Dec 2023 23:42:30 +1000
Message-ID: <20231216134257.1743345-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting a pipeline of jobs in the background seems to not have a
simple way to reliably find the pid of a particular process. The
way PID of QEMU is sometimes causes a failure waiting on a PID that
is not running when stressing migration with later changes to do
multiple migrations.

Changing this to use $! is more robust in testing, and simpler.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index cc7da7c5..4d4e791c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -131,6 +131,7 @@ run_migration ()
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
@@ -143,8 +144,9 @@ run_migration ()
 	qmpout2=/dev/null
 
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control | tee ${migout1} &
-	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
+		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+	live_pid=$!
+	cat ${migout_fifo1} | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -152,7 +154,7 @@ run_migration ()
 	mkfifo ${fifo}
 	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+	incoming_pid=$!
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -166,6 +168,9 @@ run_migration ()
 		sleep 1
 	done
 
+	# Wait until the destination has created the incoming socket
+	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
+
 	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
 
 	# Wait for the migration to complete
-- 
2.42.0


