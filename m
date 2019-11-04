Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB09EEE206
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfKDOS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:18:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727861AbfKDOS0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 09:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0eTshNdQG8iO+n6m1LPpuXW1ZVPuv/3oEAuo/WsZIfY=;
        b=AlWT2d3dzv5Zf+Mxx3sXF8OM/F5gHpIREnXSEFAdMbzjsy+eTd2gmfvyL+DDfADwOeREsC
        hgmpro+KF7fC1s4i6PRfM7yAAQ81Xg998hVkzrxM762Nn+T7ibndpkqWo9fVqRPsdKOAUY
        YYUdafDn5nEmEKpfOAjGy2albfRvh1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-OK2FKnPAPamThBQGJJew0Q-1; Mon, 04 Nov 2019 09:18:24 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90AD147A;
        Mon,  4 Nov 2019 14:18:22 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2523E60CD0;
        Mon,  4 Nov 2019 14:18:18 +0000 (UTC)
Date:   Mon, 4 Nov 2019 15:18:15 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 01/37] DOCUMENTATION: protvirt: Protected virtual machine
 introduction
Message-ID: <20191104151815.6f11a274.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-2-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: OK2FKnPAPamThBQGJJew0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:23 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Introduction to Protected VMs.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/s390-pv.txt | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/s390-pv.txt
>=20
> diff --git a/Documentation/virtual/kvm/s390-pv.txt b/Documentation/virtua=
l/kvm/s390-pv.txt
> new file mode 100644
> index 000000000000..86ed95f36759
> --- /dev/null
> +++ b/Documentation/virtual/kvm/s390-pv.txt

This should be under /virt/, I think. Also, maybe start out with RST
already for new files?

> @@ -0,0 +1,23 @@
> +Ultravisor and Protected VMs
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
> +Summary:
> +
> +Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
> +like guest memory and guest registers anymore. Instead the PVMs are

s/Instead/Instead,/

> +mostly managed by a new entity called Ultravisor (UV), which provides
> +an API, so KVM and the PVM can request management actions.

Hm...

"The UV provides an API (both for guests and hypervisors), where PVMs
and KVM can request management actions." ?

> +
> +Each guest starts in the non-protected mode and then transitions into

"and then may make a request to transition into protected mode" ?

> +protected mode. On transition KVM registers the guest and its VCPUs
> +with the Ultravisor and prepares everything for running it.
> +
> +The Ultravisor will secure and decrypt the guest's boot memory
> +(i.e. kernel/initrd). It will safeguard state changes like VCPU
> +starts/stops and injected interrupts while the guest is running.
> +
> +As access to the guest's state, like the SIE state description is

"such as the SIE state description," ?

> +normally needed to be able to run a VM, some changes have been made in
> +SIE behavior and fields have different meaning for a PVM. SIE exits
> +are minimized as much as possible to improve speed and reduce exposed
> +guest state.

