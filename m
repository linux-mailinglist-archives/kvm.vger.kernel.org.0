Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9FA158BEE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBKJdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 04:33:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726973AbgBKJdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 04:33:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581413625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OorDu29eE+PEol4sSArzlxHl7pCN4jrwJ8i6pGbkBeI=;
        b=PTYBeN9ydEoeJ00Evl5w+JqVkX4V/F5r9Af5VOODU1bt8C4g2UrlsxsOYFR7Cizgxs23ig
        YnHFh7ZaNjN7l3xwKbi1HmEizIGaXyd8tzGjOUud7gVH0mB9dYoR6tmDSv+1qxM7g8KcDQ
        Wbo1xsrae1DzqfnIV7ckMJFCY4Oabs8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-ZKewGFaXPgK9q9-hBNedNQ-1; Tue, 11 Feb 2020 04:33:43 -0500
X-MC-Unique: ZKewGFaXPgK9q9-hBNedNQ-1
Received: by mail-wr1-f72.google.com with SMTP id d8so6536777wrq.12
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 01:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OorDu29eE+PEol4sSArzlxHl7pCN4jrwJ8i6pGbkBeI=;
        b=l3n5K0R9apz0hq7Wq/Xdk1wJiNQM98SoqXIUTtS7zucaR+f2SZJoFGvaDDT78KGpp1
         qwGvWglHpXIocPPqQcAlPHWKvkQkqhVdPitKa3x/+a++V7AJ1uAD4mBHATE4lgFb3mlU
         K7Igt0hBolyBpJ4PJ6BePyP5PbdqEiPLSK99LUUzHw+q6jOdsUYkAMl5tDh/lom+jhxO
         PYaLdJQ1/wduN5z5A9rXo6L/cbP8JDjlVGT94X/gneQxPEkSjvbCa9K73IhWxpRrZNSc
         rlNTlYUMMIY52VwzuCQB5cAY8fcKNXGXTKdXyYMfLKj5JaGANgC5CqbntdsoWjC4KsSM
         ZveQ==
X-Gm-Message-State: APjAAAWWm8/Sqp/V7dVwJ5OtdeBzCMv3tvh0gpikd15yaB+CSR4LICb/
        6j1gPomVcdzxlYxd5XjzP4Wy8PUer3lNMlskWqs8pnMPwHsJdJNXPRfT767uNat8AKrISqIJyw9
        uKpEAsARoY7Bq
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr4480291wmb.19.1581413622484;
        Tue, 11 Feb 2020 01:33:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqw7fKqgsGAyA5ikiliDn3jmpl1I5sX0SlqMj+bcLy70PjqPun6qfyugqk9My5h3IwXcNukCPg==
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr4480274wmb.19.1581413622269;
        Tue, 11 Feb 2020 01:33:42 -0800 (PST)
Received: from eperezma.remote.csb (121.142.221.87.dynamic.jazztel.es. [87.221.142.121])
        by smtp.gmail.com with ESMTPSA id s8sm3070475wmf.45.2020.02.11.01.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 01:33:41 -0800 (PST)
Message-ID: <5119e785ed98cc446ad96d893bd2c6efa127f8e1.camel@redhat.com>
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
Date:   Tue, 11 Feb 2020 10:33:39 +0100
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

Hi Christian. Thank you very much for the hints.

Could we add some debug traces? Something like the inline patch should give us some clues.

Thanks!

From a8d65d5f0ae3d305443ee84b4842b7c712a1ac1d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Date: Tue, 11 Feb 2020 10:29:01 +0100
Subject: [PATCH] Add some traces

---
 drivers/vhost/vhost.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b5a51b1f2e79..60c048eebe4d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2239,8 +2239,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
 		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
-				last_avail_idx, vq->avail_idx);
+			vq_err(vq, "Guest moved vq %p used index from %u to %u",
+				vq, last_avail_idx, vq->avail_idx);
 			return -EFAULT;
 		}
 
@@ -2336,6 +2336,8 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	while (!ret && vq->ndescs <= vq->batch_descs)
 		ret = fetch_buf(vq);
 
+	pr_debug("[vq=%p][vq->ndescs=%d]", vq, vq->ndescs);
+
 	return vq->ndescs ? 0 : ret;
 }
 
@@ -2416,6 +2418,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	}
 
 	vq->first_desc = i + 1;
+	pr_debug("[vq=%p][vq->ndescs=%d][vq->first_desc=%d]", vq, vq->ndescs,
+		 vq->first_desc);
 
 	return ret;
 
@@ -2459,6 +2463,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 
 	start = vq->last_used_idx & (vq->num - 1);
 	used = vq->used->ring + start;
+	pr_debug("[vq=%p][start=%d][count=%u]", vq, start, count);
 	if (vhost_put_used(vq, heads, start, count)) {
 		vq_err(vq, "Failed to write used");
 		return -EFAULT;
-- 
2.18.1

