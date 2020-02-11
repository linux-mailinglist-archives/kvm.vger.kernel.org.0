Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1DD158F71
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgBKNFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:05:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728666AbgBKNFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581426302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kqt8vtCIW6YAIOlkwJ37g/dGZjDycn7sBle2ILD4zxA=;
        b=CruwuqfjvWXpcR85wgsgEb9bjWrF9mJiNlGZ1i+0IcW7cAxlPDUl6zY8yg5PAt1yhfKbr5
        vkU/032pvLv3TS+uxp2HB0YDjZkNOnmqvipbmu40X3x3aOzW/N12TmqTv3C6GU6alOri94
        LQKAy8q5ssZr/+WVaYDCBU6TnbmTA78=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-ROJnJqtWM1mj0sFiKtgoHw-1; Tue, 11 Feb 2020 08:05:00 -0500
X-MC-Unique: ROJnJqtWM1mj0sFiKtgoHw-1
Received: by mail-wr1-f71.google.com with SMTP id t6so6839684wru.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 05:05:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kqt8vtCIW6YAIOlkwJ37g/dGZjDycn7sBle2ILD4zxA=;
        b=f7ZayHkmy47VYEC/ydcOVB3oDPf//O5JSJrAmrIVPVv+ALS574eeG9iW5gQk86JgaZ
         VRSoWxnzVlJXkDD8T1YoZZTXLsPPhzqnODTk9LBQbN65+/Vi0EdFipXWMHy+0M/Zjhlk
         CWoZQpX/PXgvqSLsF3NecFvApwRrySOc0Dd75tpXYFcf09zS2frImTf8PF4VPmCJ1M3U
         iDlRVQ96gR+RbfXVvMrX6gMgX9uk66SZmm/tDg+ZFq0k2R5xaiAsTychoWcrdZuRxquR
         +1AfaXEvTskX8TiokbuEr2eA3wQCXbVIAZiaXibD4FRCOt9Q6MftdBDBxRH2iC9UAui0
         bBPg==
X-Gm-Message-State: APjAAAXEgrLWD2853rV0SsQi4OLgowbLagLMkyVwe+tuJegD4jVqprit
        8wv/dWT9PH3voMsJ5EuDRuYlD6QNePP27VAqA1qKwEio9qogJ7jvyIXdRt/QT4qTzlCXeAbGTcS
        9Bbq/e/qVG7Te
X-Received: by 2002:a1c:6755:: with SMTP id b82mr5319157wmc.127.1581426299318;
        Tue, 11 Feb 2020 05:04:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmKyPbRozPTEG8zxNdGYI5O2FSVLwMWkgPtbCQkwJ3DD9ducdeXjnrmKcGk+ai79rusLwduw==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr5319012wmc.127.1581426297509;
        Tue, 11 Feb 2020 05:04:57 -0800 (PST)
Received: from eperezma.remote.csb (121.142.221.87.dynamic.jazztel.es. [87.221.142.121])
        by smtp.gmail.com with ESMTPSA id o2sm3531044wmh.46.2020.02.11.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 05:04:57 -0800 (PST)
Message-ID: <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger
 random crashes in KVM guests after reboot
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Date:   Tue, 11 Feb 2020 14:04:54 +0100
In-Reply-To: <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
         <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
         <20200107065434-mutt-send-email-mst@kernel.org>
         <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
         <20200120012724-mutt-send-email-mst@kernel.org>
         <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
         <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
         <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
         <20200206171349-mutt-send-email-mst@kernel.org>
         <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
         <20200207025806-mutt-send-email-mst@kernel.org>
         <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com>
         <CAJaqyWfngzP4d01B6+Sqt8FXN6jX7kGegjx8ie4no_1Er3igQA@mail.gmail.com>
         <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-02-10 at 12:01 +0100, Christian Borntraeger wrote:
> 
> On 10.02.20 10:47, Eugenio Perez Martin wrote:
> > Hi Christian.
> > 
> > I'm not able to reproduce the failure with eccb852f1fe6bede630e2e4f1a121a81e34354ab commit. Could you add more data?
> > Your configuration (libvirt or qemu line), and host's dmesg output if any?
> > 
> > Thanks!
> 
> If it was not obvious, this is on s390x, a big endian system.
> 

Hi Christian. Thank you very much for your fast responses.

Could you try this patch on top of eccb852f1fe6bede630e2e4f1a121a81e34354ab?

Thanks!

From 71d0f9108a18aa894cc0c0c1c7efbad39f465a27 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <
eperezma@redhat.com>
Date: Tue, 11 Feb 2020 13:19:10 +0100
Subject: [PATCH] vhost: fix return value of vhost_get_vq_desc

Before of the batch change, it was the chain's head. Need to keep that
way or we will not be able to free a chain of descriptors.

Fixes: eccb852f1fe6 ("vhost: batching fetches")
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b5a51b1f2e79..fc422c3e5c08 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2409,12 +2409,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			*out_num += ret;
 		}
 
-		ret = desc->id;
-
 		if (!(desc->flags & VRING_DESC_F_NEXT))
 			break;
 	}
 
+	ret = vq->descs[vq->first_desc].id;
 	vq->first_desc = i + 1;
 
 	return ret;
-- 
2.18.1

