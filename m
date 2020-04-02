Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE40519BD6D
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbgDBIRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:17:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30485 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387601AbgDBIRl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585815460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qrXk8LVQd/CXKhg1TsCqsO3eX0JuDNOSoaTAXR1nr78=;
        b=QpMmA0a3ViOskkEX0qZIgwy8adP+b9m+zeWJh/ydJdfeKttDVaiTaJRwHWlV1mP4y2qUMh
        WUxGpVWMYOZ0Cr4Y/7xsFnjDcDe7GwnXXk/TG9ayptY9Noy0VAOzOMkOOzScuuraVFiwnk
        MUoJInVYyAfngKi5LtONidV9kUhWE6E=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-2Mz360cANB-sM2CJu5cowA-1; Thu, 02 Apr 2020 04:17:38 -0400
X-MC-Unique: 2Mz360cANB-sM2CJu5cowA-1
Received: by mail-qk1-f199.google.com with SMTP id d189so44033qkc.15
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 01:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qrXk8LVQd/CXKhg1TsCqsO3eX0JuDNOSoaTAXR1nr78=;
        b=RImhq624jf5oQr3sE2JvoWfhIHPLHep0c83EanUlbfxTMCkmzJ1BPHA5QGuCAmEwgp
         gaEwLKTcnVgZ92lOQ2EsFsiNQ7X2W3YxFZHaH/QhT8qv8bF1nzMzn9MgSzWzLJlSKk99
         Ty4wvPDHZxRscObKoW5YoLLkOUR7c9LG+fCkbQMlZk9w85yGNPxS/0eUpxDFhFB1Krmk
         j5D2jIY8nE8ixEvU6d/eIO95WNGnjgeOA5CwfbZ5otDWBICPri+sBCYlJkTtQOmZbZk0
         fJzg1fV7sCvJ5XwW7UtzNDCIgsX6d17bYftdLmmCtOk1U/AdjeU2cTk0nevkHqz17/NX
         8keA==
X-Gm-Message-State: AGi0PuYyGFLx0B83K6ESPT03+CQrwCeZyysdzdbMBi19BiPw+ldPnq3z
        fwCMM7ndI1mMRqSlpINeB6PoSlIO1muqcwEigKUHeCJrWpFecDIPnYPhmeE+zATf9xuW0hbfCUM
        GkUmQ2yKsD8OgTKbIay14V22n2z8c
X-Received: by 2002:ac8:740b:: with SMTP id p11mr1626584qtq.379.1585815457649;
        Thu, 02 Apr 2020 01:17:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypIWKQ0r7BLw/mXFg9PX+PpdHbG2jGnLDwo9XSxTQBg5Q2ggffGwidECmAS47ycvsUD64mF34zIwUE9GnhztrQo=
X-Received: by 2002:ac8:740b:: with SMTP id p11mr1626573qtq.379.1585815457383;
 Thu, 02 Apr 2020 01:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200331192804.6019-1-eperezma@redhat.com> <c4d2b0b4-0b6d-cd74-0eb5-e7fdfe063d42@de.ibm.com>
 <CAJaqyWc+fNzHE_p-pApZtj2ypNQfFLawCWf8GJmP8e=k=C+EgA@mail.gmail.com>
 <916e60f8-45fe-5cc1-d5a1-defdcd00d75b@de.ibm.com> <6d16572f-34e9-4806-a5f8-94d8f75db352@de.ibm.com>
In-Reply-To: <6d16572f-34e9-4806-a5f8-94d8f75db352@de.ibm.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 2 Apr 2020 10:17:01 +0200
Message-ID: <CAJaqyWdwqdyfY_ZrWXEGogoUKajEPpT3FdsDMdEUCZ0tt4Dh9w@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] vhost: Reset batched descriptors on SET_VRING_BASE call
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 1, 2020 at 9:13 PM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> >> Would it be possible to investigate when qemu launches the offending ioctls?
> >
> > During guest reboot. This is obvious, no?
> >
>

Got it. I thought you received it after the reboot AND once you sent
the firsts packets, since you said that some pings worked. But now
that this point is clear, I think we can move forward :). Thank you
very much!


>
> For example during reboot we do re-setup the virt queues:
>
> #1  0x00000000010f3e7a in vhost_kernel_set_vring_base (dev=0x21f5f30, ring=0x3ff84d74e88) at /home/cborntra/REPOS/qemu/hw/virtio/vhost-backend.c:126
> #2  0x00000000010f2f92 in vhost_virtqueue_start (idx=0, vq=0x21f6180, vdev=0x241d570, dev=0x21f5f30) at /home/cborntra/REPOS/qemu/hw/virtio/vhost.c:1016
> #3  vhost_dev_start (hdev=hdev@entry=0x21f5f30, vdev=vdev@entry=0x241d570) at /home/cborntra/REPOS/qemu/hw/virtio/vhost.c:1646
> #4  0x00000000011c265a in vhost_net_start_one (dev=0x241d570, net=0x21f5f30) at /home/cborntra/REPOS/qemu/hw/net/vhost_net.c:236
> #5  vhost_net_start (dev=dev@entry=0x241d570, ncs=0x2450f40, total_queues=total_queues@entry=1) at /home/cborntra/REPOS/qemu/hw/net/vhost_net.c:338
> #6  0x00000000010cfdfe in virtio_net_vhost_status (status=15 '\017', n=0x241d570) at /home/cborntra/REPOS/qemu/hw/net/virtio-net.c:250
> #7  virtio_net_set_status (vdev=0x241d570, status=<optimized out>) at /home/cborntra/REPOS/qemu/hw/net/virtio-net.c:331
> #8  0x00000000010eaef4 in virtio_set_status (vdev=vdev@entry=0x241d570, val=<optimized out>) at /home/cborntra/REPOS/qemu/hw/virtio/virtio.c:1956
> #9  0x000000000110ba78 in virtio_ccw_cb (sch=0x2422c30, ccw=...) at /home/cborntra/REPOS/qemu/hw/s390x/virtio-ccw.c:509
> #10 0x00000000011053fc in css_interpret_ccw (sch=sch@entry=0x2422c30, ccw_addr=<optimized out>, suspend_allowed=suspend_allowed@entry=false) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1108
> #11 0x000000000110557c in sch_handle_start_func_virtual (sch=0x2422c30) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1162
> #12 do_subchannel_work_virtual (sch=0x2422c30) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1256
> #13 0x0000000001168592 in ioinst_handle_ssch (cpu=cpu@entry=0x234b920, reg1=<optimized out>, ipb=<optimized out>, ra=ra@entry=0) at /home/cborntra/REPOS/qemu/target/s390x/ioinst.c:218
> #14 0x0000000001170012 in handle_b2 (ipa1=<optimized out>, run=0x3ff97880000, cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1279
> #15 handle_instruction (run=0x3ff97880000, cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1664
> #16 handle_intercept (cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1747
> #17 kvm_arch_handle_exit (cs=cs@entry=0x234b920, run=run@entry=0x3ff97880000) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1937
> #18 0x00000000010972dc in kvm_cpu_exec (cpu=cpu@entry=0x234b920) at /home/cborntra/REPOS/qemu/accel/kvm/kvm-all.c:2445
> #19 0x00000000010784f6 in qemu_kvm_cpu_thread_fn (arg=0x234b920) at /home/cborntra/REPOS/qemu/cpus.c:1246
> #20 qemu_kvm_cpu_thread_fn (arg=arg@entry=0x234b920) at /home/cborntra/REPOS/qemu/cpus.c:1218
> #21 0x00000000013891fa in qemu_thread_start (args=0x2372f30) at /home/cborntra/REPOS/qemu/util/qemu-thread-posix.c:519
> #22 0x000003ff93809ed6 in start_thread () from target:/lib64/libpthread.so.0
> #23 0x000003ff93705e46 in thread_start () from target:/lib64/libc.so.6
>

