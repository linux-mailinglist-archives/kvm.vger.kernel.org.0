Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F5C15BD0C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 11:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgBMKrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 05:47:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55934 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729511AbgBMKra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 05:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581590849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPavP7GkPHbA9nAIhJpPzFBRx/ipmprf5jJA6A1kd3I=;
        b=IVwdEdwO6yxxcbWrLpaHHMHpzh/zlxQSnEg/6UZrdFEv2xIVRAMLQMFe95dflK1NpK6ru7
        +JO2cR1iNmKZjUc4b2bhw7SVVn2R2+0MIAVFNkOshoUZTxrgceXy/zLaDvTZ0NV1beWt+m
        FDrIWVsphqsVjouyJXv3zvafLLmrLB4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-KWK9goRPNBONMF5uQIziTQ-1; Thu, 13 Feb 2020 05:47:27 -0500
X-MC-Unique: KWK9goRPNBONMF5uQIziTQ-1
Received: by mail-wm1-f69.google.com with SMTP id y24so2162098wmj.8
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 02:47:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPavP7GkPHbA9nAIhJpPzFBRx/ipmprf5jJA6A1kd3I=;
        b=nb0ZOVjhhDaLhNp62mjvKav2kqm+2cirVlwXtrKVZYSR7Ar1g5ric8kq8I1l0bn+Me
         FwRBanc8ptJyisqwXz/F/t250PtKa4StjEHi2cbBS/3Vw0AXMdoxytUdneya+wEMT+EO
         iI17iiyAqzFXjvW21Z1eUZq06c/ity2Yy30V8PpcxVTlWkub0Z43zCDChYL9wWzq6BeJ
         OcrbOgsEznUpCqDRut+FqR05reqd4TUAQRj1OmGumvU1Ah0l/86Ca/al6bLhCrcoxiy/
         ZeXMuGrY56Lt8qsXa3G8MuT2Zz6mkpx9S1WQSvQYUiXsWugcRp1qSqo01d6zaaOZLuzH
         s5GA==
X-Gm-Message-State: APjAAAWBXB0FMmotdY3+86HgLN2h9uLReM+TB1wU93YeGJS+BqVNtGFY
        DcHmaYzGqB+Y/fuK8kVW7y7bYl4Iw1e7zG3qlgtFJoNT3hk0FElO6CURXgP4o6K1CRtZoswZLeP
        RdVhN0GmZ/z4h
X-Received: by 2002:adf:df83:: with SMTP id z3mr21011689wrl.389.1581590845894;
        Thu, 13 Feb 2020 02:47:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCeSPA8ip2eIMnBtF6Hp8YnjH56/8V12XtNP6D3ErRElYxrh0GLTirRpucYtXyJbwf03MvnQ==
X-Received: by 2002:adf:df83:: with SMTP id z3mr21011663wrl.389.1581590845584;
        Thu, 13 Feb 2020 02:47:25 -0800 (PST)
Received: from eperezma.remote.csb (246.141.221.87.dynamic.jazztel.es. [87.221.141.246])
        by smtp.gmail.com with ESMTPSA id n3sm2529543wmc.27.2020.02.13.02.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 02:47:24 -0800 (PST)
Message-ID: <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
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
Date:   Thu, 13 Feb 2020 11:47:23 +0100
In-Reply-To: <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
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
         <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
         <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
         <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
         <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-02-13 at 10:30 +0100, Christian Borntraeger wrote:
> 
> On 12.02.20 17:34, Eugenio Pérez wrote:
> > On Tue, 2020-02-11 at 14:13 +0100, Christian Borntraeger wrote:
> > > On 11.02.20 14:04, Eugenio Pérez wrote:
> > > > On Mon, 2020-02-10 at 12:01 +0100, Christian Borntraeger wrote:
> > > > > On 10.02.20 10:47, Eugenio Perez Martin wrote:
> > > > > > Hi Christian.
> > > > > > 
> > > > > > I'm not able to reproduce the failure with eccb852f1fe6bede630e2e4f1a121a81e34354ab commit. Could you add
> > > > > > more
> > > > > > data?
> > > > > > Your configuration (libvirt or qemu line), and host's dmesg output if any?
> > > > > > 
> > > > > > Thanks!
> > > > > 
> > > > > If it was not obvious, this is on s390x, a big endian system.
> > > > > 
> > > > 
> > > > Hi Christian. Thank you very much for your fast responses.
> > > > 
> > > > Could you try this patch on top of eccb852f1fe6bede630e2e4f1a121a81e34354ab?
> > > 
> > > I still get 
> > > [   43.665145] Guest moved used index from 0 to 289
> > > after some reboots.
> > > 
> > > 
> > > > Thanks!
> > > > 
> > > > From 71d0f9108a18aa894cc0c0c1c7efbad39f465a27 Mon Sep 17 00:00:00 2001
> > > > From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <
> > > > eperezma@redhat.com>
> > > > Date: Tue, 11 Feb 2020 13:19:10 +0100
> > > > Subject: [PATCH] vhost: fix return value of vhost_get_vq_desc
> > > > 
> > > > Before of the batch change, it was the chain's head. Need to keep that
> > > > way or we will not be able to free a chain of descriptors.
> > > > 
> > > > Fixes: eccb852f1fe6 ("vhost: batching fetches")
> > > > ---
> > > >  drivers/vhost/vhost.c | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index b5a51b1f2e79..fc422c3e5c08 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -2409,12 +2409,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> > > >  			*out_num += ret;
> > > >  		}
> > > >  
> > > > -		ret = desc->id;
> > > > -
> > > >  		if (!(desc->flags & VRING_DESC_F_NEXT))
> > > >  			break;
> > > >  	}
> > > >  
> > > > +	ret = vq->descs[vq->first_desc].id;
> > > >  	vq->first_desc = i + 1;
> > > >  
> > > >  	return ret;
> > > > 
> > 
> > Sorry, still not able to reproduce the issue.
> > 
> > Could we try to disable all the vhost features?
> > 
> > Thanks!
> > 
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 661088ae6dc7..08f6d2ccb697 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -250,11 +250,11 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
> >         } while (0)
> >  
> >  enum {
> > -       VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> > -                        (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> > -                        (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> > -                        (1ULL << VHOST_F_LOG_ALL) |
> > -                        (1ULL << VIRTIO_F_ANY_LAYOUT) |
> > +       VHOST_FEATURES = /* (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) | */
> > +                        /* (1ULL << VIRTIO_RING_F_INDIRECT_DESC) | */
> > +                        /* (1ULL << VIRTIO_RING_F_EVENT_IDX) | */
> > +                        /* (1ULL << VHOST_F_LOG_ALL) | */
> > +                        /* (1ULL << VIRTIO_F_ANY_LAYOUT) | */
> >                          (1ULL << VIRTIO_F_VERSION_1)
> >  };
> > 
> 
> I still get  guest crashes with this on top of eccb852f1fe6. (The patch did not
> apply, I had to manually comment out these things)
> 

Sorry about that, I C&P transformed tabs to spaces.

Can we try tracing last_avail_idx with the attached patch? Can you enable also line and thread id (dyndbg='+plt')?

Thanks!

From f7012e8b9db711b12d36e6e97411e7afa34bf768 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Date: Thu, 13 Feb 2020 11:26:06 +0100
Subject: [PATCH] vhost: disable all features and trace last_avail_idx

---
 drivers/vhost/vhost.c | 13 +++++++++++--
 drivers/vhost/vhost.h | 10 +++++-----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index fc422c3e5c08..021d70bed015 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1645,6 +1645,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
+		pr_debug(
+			"VHOST_SET_VRING_BASE [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u]",
+			vq, vq->last_avail_idx, vq->avail_idx);
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
@@ -2239,8 +2242,8 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
 		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
-				last_avail_idx, vq->avail_idx);
+			vq_err(vq, "Guest moved vq %p used index from %u to %u",
+				vq, last_avail_idx, vq->avail_idx);
 			return -EFAULT;
 		}
 
@@ -2316,6 +2319,9 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 
 	/* On success, increment avail index. */
+	pr_debug(
+		"[vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][vq->ndescs=%d][vq->first_desc=%d]",
+		vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->first_desc);
 	vq->last_avail_idx++;
 
 	return 0;
@@ -2431,6 +2437,9 @@ EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
+	pr_debug(
+		"DISCARD [vq=%p][vq->last_avail_idx=%u][vq->avail_idx=%u][n=%d]",
+		vq, vq->last_avail_idx, vq->avail_idx, n);
 	vq->last_avail_idx -= n;
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 661088ae6dc7..08f6d2ccb697 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -250,11 +250,11 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
 	} while (0)
 
 enum {
-	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
-			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
-			 (1ULL << VHOST_F_LOG_ALL) |
-			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
+	VHOST_FEATURES = /* (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) | */
+			 /* (1ULL << VIRTIO_RING_F_INDIRECT_DESC) | */
+			 /* (1ULL << VIRTIO_RING_F_EVENT_IDX) | */
+			 /* (1ULL << VHOST_F_LOG_ALL) | */
+			 /* (1ULL << VIRTIO_F_ANY_LAYOUT) | */
 			 (1ULL << VIRTIO_F_VERSION_1)
 };
 
-- 
2.18.1


