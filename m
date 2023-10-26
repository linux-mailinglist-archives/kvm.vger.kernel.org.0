Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE9B7D7E78
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 10:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344527AbjJZI1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 04:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjJZI1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 04:27:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7948DE
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698308822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiXFBc8YsDvBzhxHytTZjcWCexeiPcrWUoCrLdYurNk=;
        b=eXTXH5J8BN6QRDRhuIJ5OoKlIFTDQDYVQouAGW8ermI3XZ95IGYBU7KG44MNGVJb5GxgcX
        OYisKMMxTv4vu/xhDZzdFtOlildXZHemMavUFrbbgeHyetO4Xw78NWd1NRHIXkFQvw6dqB
        GVHM8fKB0ukHDOka/B/D86fa/Zc1Uj0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-AfOJAuHtP6SZAVeVp_QaGw-1; Thu, 26 Oct 2023 04:26:57 -0400
X-MC-Unique: AfOJAuHtP6SZAVeVp_QaGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E338F811E7D;
        Thu, 26 Oct 2023 08:26:56 +0000 (UTC)
Received: from redhat.com (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E8EC40C6F79;
        Thu, 26 Oct 2023 08:26:54 +0000 (UTC)
Date:   Thu, 26 Oct 2023 10:26:53 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Eric Blake <eblake@redhat.com>, qemu-devel@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: Re: [PATCH v3 28/28] docs: update Xen-on-KVM documentation
Message-ID: <ZToizYcPjO0Zt52N@redhat.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-29-dwmw2@infradead.org>
 <6vbpkrebc7fpypbv2t7jbs7m3suxwbqqykeomzfxpenjj2sogd@rphcppcl4inl>
 <4a10a50e5469480a82cb993dedbff10c3d777082.camel@infradead.org>
 <21e8a265-bf5a-464c-86bc-f0fd7b5eb108@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21e8a265-bf5a-464c-86bc-f0fd7b5eb108@citrix.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 25.10.2023 um 20:56 hat Andrew Cooper geschrieben:
> On 25/10/2023 7:26 pm, David Woodhouse wrote:
> > On Wed, 2023-10-25 at 13:20 -0500, Eric Blake wrote:
> >> On Wed, Oct 25, 2023 at 03:50:42PM +0100, David Woodhouse wrote:
> >>> +
> >>> +Booting Xen PV guests
> >>> +---------------------
> >>> +
> >>> +Booting PV guest kernels is possible by using the Xen PV shim (a version of Xen
> >>> +itself, designed to run inside a Xen HVM guest and provide memory management
> >>> +services for one guest alone).
> >>> +
> >>> +The Xen binary is provided as the ``-kernel`` and the guest kernel itself (or
> >>> +PV Grub image) as the ``-initrd`` image, which actually just means the first
> >>> +multiboot "module". For example:
> >>> +
> >>> +.. parsed-literal::
> >>> +
> >>> +  |qemu_system| --accel kvm,xen-version=0x40011,kernel-irqchip=split \\
> >>> +       -chardev stdio,id=char0 -device xen-console,chardev=char0 \\
> >>> +       -display none  -m 1G  -kernel xen -initrd bzImage \\
> >>> +       -append "pv-shim console=xen,pv -- console=hvc0 root=/dev/xvda1" \\
> >>> +       -drive file=${GUEST_IMAGE},if=xen
> >> Is the space between -- and console= intentionsl?
> > Yes, that one is correct. The -- is how you separate Xen's command line
> > (on the left) from the guest kernel command line (on the right).
> 
> To expand on this a bit.
> 
> Multiboot1 supports multiple modules but only a single command line.  As
> one of the modules passed to Xen is the dom0 kernel, we need some way to
> pass it's command line, hence the " -- ".

That's not right, even Multiboot 1 contains a 'string' field in the
module structure that is defined to typically hold a command line. The
exact meaning is OS dependent, so Xen could use it however it wants.

In QEMU (and I believe this is the same behaviour as in GRUB),
everything before the space in an -initrd argument is treated as a
filename to load, everything after it is just passed as the command
line.

So it would have been entirely possible to use -initrd 'bzImage
console=hvc0 root=/dev/xvda1' if Xen worked like that.

> Multiboot2 and PVH support a command line per module, which is the
> preferred way to pass the commandlines, given a choice.

Multiboot 2 seems to integrate the string in a variable length module
structure instead of just having a pointer in a fixed length one, but
the model behind it is essentially the same as before.

Kevin

