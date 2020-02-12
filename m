Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8E15AD76
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgBLQeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:34:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727231AbgBLQeV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 11:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581525261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XeLe0VqvdqoWiGR03rxndmykwmmXsnBvd6JZdgln7y4=;
        b=POlhJANYimN8IanVDLDyKw5Vm92rElusmK1HDa36YIsL0TR/GUlzBc2rg+uPesIbsxFgNq
        Ye3beJ3IcgEzFLVgIiqeovem1t5Hxl/cDuWjImWiBTaH/mLic/WIbAcMcp96kd9RVUGHb9
        /t64QnwgNzPjBWffstFgO3V2dzmh5CY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-mk05eiBTMyqgeHwtHIpuMw-1; Wed, 12 Feb 2020 11:34:19 -0500
X-MC-Unique: mk05eiBTMyqgeHwtHIpuMw-1
Received: by mail-wr1-f72.google.com with SMTP id w6so1025623wrm.16
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XeLe0VqvdqoWiGR03rxndmykwmmXsnBvd6JZdgln7y4=;
        b=Q7kD35orp6I8dTamkncdXHEJ50vom3uysApScay+prC17bD8eHvMaLporfP+ZBmBJj
         d0tvf7hVQUWiPXaclSDHAG1hfrTX9a1BhXFQfTkD/DB52nXpKqYNhROZdJuBP/lvZwYg
         Mr6J/kKqjFxtW1gOt6RHkbzvprJnCpyokH8G2fHyUAezGNFlOG0FScb8dSPA04EbnlBg
         UbCpNBE/+DfvCfMz/xMquOgXp0VIHaTiGa9oLrIIwTmLqFjOcy02XA8qmFEPijOM0VjO
         GLCd498OcOnq/tbe5OO2ltUaT25RRxhpTeW7QYmNIhJ2q4RJTyD5pUG3YHnSmF8G4Kyo
         ZdUg==
X-Gm-Message-State: APjAAAXCJVUo9VGDhEFdOwpVVG3oePusPt16++m0phQtkpQtEpIekzsK
        VG0KMBTMJflnjDR5zCvvF9pGN1q8kl/LV5m4s6wiBnMmDJgR6o4RHTHIkjfrNtVTq7cimKqEbP+
        H4ysP8nqXr2eT
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr13953428wmj.72.1581525258504;
        Wed, 12 Feb 2020 08:34:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzR9LoAw0PLm1NN8TKVgvBlTdyQ4+WmwfyRs+Y2SnZ+YimN+K/oDsDwHuGaXIU12ce2wCypA==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr13953400wmj.72.1581525258231;
        Wed, 12 Feb 2020 08:34:18 -0800 (PST)
Received: from eperezma.remote.csb (153.143.221.87.dynamic.jazztel.es. [87.221.143.153])
        by smtp.gmail.com with ESMTPSA id a16sm1172111wrt.30.2020.02.12.08.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 08:34:17 -0800 (PST)
Message-ID: <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
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
Date:   Wed, 12 Feb 2020 17:34:16 +0100
In-Reply-To: <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-11 at 14:13 +0100, Christian Borntraeger wrote:
> 
> On 11.02.20 14:04, Eugenio Pérez wrote:
> > On Mon, 2020-02-10 at 12:01 +0100, Christian Borntraeger wrote:
> > > On 10.02.20 10:47, Eugenio Perez Martin wrote:
> > > > Hi Christian.
> > > > 
> > > > I'm not able to reproduce the failure with eccb852f1fe6bede630e2e4f1a121a81e34354ab commit. Could you add more
> > > > data?
> > > > Your configuration (libvirt or qemu line), and host's dmesg output if any?
> > > > 
> > > > Thanks!
> > > 
> > > If it was not obvious, this is on s390x, a big endian system.
> > > 
> > 
> > Hi Christian. Thank you very much for your fast responses.
> > 
> > Could you try this patch on top of eccb852f1fe6bede630e2e4f1a121a81e34354ab?
> 
> I still get 
> [   43.665145] Guest moved used index from 0 to 289
> after some reboots.
> 
> 
> > Thanks!
> > 
> > From 71d0f9108a18aa894cc0c0c1c7efbad39f465a27 Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <
> > eperezma@redhat.com>
> > Date: Tue, 11 Feb 2020 13:19:10 +0100
> > Subject: [PATCH] vhost: fix return value of vhost_get_vq_desc
> > 
> > Before of the batch change, it was the chain's head. Need to keep that
> > way or we will not be able to free a chain of descriptors.
> > 
> > Fixes: eccb852f1fe6 ("vhost: batching fetches")
> > ---
> >  drivers/vhost/vhost.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index b5a51b1f2e79..fc422c3e5c08 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -2409,12 +2409,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> >  			*out_num += ret;
> >  		}
> >  
> > -		ret = desc->id;
> > -
> >  		if (!(desc->flags & VRING_DESC_F_NEXT))
> >  			break;
> >  	}
> >  
> > +	ret = vq->descs[vq->first_desc].id;
> >  	vq->first_desc = i + 1;
> >  
> >  	return ret;
> > 

Sorry, still not able to reproduce the issue.

Could we try to disable all the vhost features?

Thanks!

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 661088ae6dc7..08f6d2ccb697 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -250,11 +250,11 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
        } while (0)
 
 enum {
-       VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
-                        (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-                        (1ULL << VIRTIO_RING_F_EVENT_IDX) |
-                        (1ULL << VHOST_F_LOG_ALL) |
-                        (1ULL << VIRTIO_F_ANY_LAYOUT) |
+       VHOST_FEATURES = /* (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) | */
+                        /* (1ULL << VIRTIO_RING_F_INDIRECT_DESC) | */
+                        /* (1ULL << VIRTIO_RING_F_EVENT_IDX) | */
+                        /* (1ULL << VHOST_F_LOG_ALL) | */
+                        /* (1ULL << VIRTIO_F_ANY_LAYOUT) | */
                         (1ULL << VIRTIO_F_VERSION_1)
 };

