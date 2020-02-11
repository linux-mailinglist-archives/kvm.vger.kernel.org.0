Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242CE158E60
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 13:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgBKMXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 07:23:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727264AbgBKMXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 07:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=EqC7vP3ZSffmHke4sKuIGyItxX4oZMFilYOT6bQzcQ8=;
        b=CzEKOBvrzoiLC8bv+fB9rWguvaRUdfA5TGcsS/HGDgGQiyghNzHIJRIoupXPuWguthGyJM
        hFPL+iZNn5NOIxgUaZLiHW9agJItxZly8jUZNz5lD+1j10K00qf6XuIdlokOL0wKmRmpjB
        tshBpl58wwjfWf0vHA8xWYICOFlsvsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-n6p7h0y7NjCjF2K7-cqODg-1; Tue, 11 Feb 2020 07:23:47 -0500
X-MC-Unique: n6p7h0y7NjCjF2K7-cqODg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0665C107ACC5;
        Tue, 11 Feb 2020 12:23:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-131.ams2.redhat.com [10.36.116.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1F5560BF4;
        Tue, 11 Feb 2020 12:23:40 +0000 (UTC)
Subject: Re: [PATCH 35/35] DOCUMENTATION: Protected virtual machine
 introduction and IPL
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-36-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5d8050a6-c730-4325-2d46-2b5c9cdc8408@redhat.com>
Date:   Tue, 11 Feb 2020 13:23:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-36-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> Add documentation about protected KVM guests and description of changes
> that are necessary to move a KVM VM into Protected Virtualization mode.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: fixing and conversion to rst]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
[...]
> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/vi=
rt/kvm/s390-pv-boot.rst
> new file mode 100644
> index 000000000000..47814e53369a
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
> @@ -0,0 +1,79 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +s390 (IBM Z) Boot/IPL of Protected VMs
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Summary
> +-------
> +Protected Virtual Machines (PVM) are not accessible by I/O or the
> +hypervisor.  When the hypervisor wants to access the memory of PVMs
> +the memory needs to be made accessible. When doing so, the memory will
> +be encrypted.  See :doc:`s390-pv` for details.
> +
> +On IPL a small plaintext bootloader is started which provides
> +information about the encrypted components and necessary metadata to
> +KVM to decrypt the protected virtual machine.
> +
> +Based on this data, KVM will make the protected virtual machine known
> +to the Ultravisor(UV) and instruct it to secure the memory of the PVM,
> +decrypt the components and verify the data and address list hashes, to
> +ensure integrity. Afterwards KVM can run the PVM via the SIE
> +instruction which the UV will intercept and execute on KVM's behalf.
> +
> +The switch into PV mode lets us load encrypted guest executables and

Maybe rather: "After the switch into PV mode, the guest can load ..." ?

> +data via every available method (network, dasd, scsi, direct kernel,
> +...) without the need to change the boot process.
> +
> +
> +Diag308
> +-------
> +This diagnose instruction is the basis for VM IPL. The VM can set and
> +retrieve IPL information blocks, that specify the IPL method/devices
> +and request VM memory and subsystem resets, as well as IPLs.
> +
> +For PVs this concept has been extended with new subcodes:
> +
> +Subcode 8: Set an IPL Information Block of type 5 (information block
> +for PVMs)
> +Subcode 9: Store the saved block in guest memory
> +Subcode 10: Move into Protected Virtualization mode
> +
> +The new PV load-device-specific-parameters field specifies all data,

remove the comma?

> +that is necessary to move into PV mode.
> +
> +* PV Header origin
> +* PV Header length
> +* List of Components composed of
> +   * AES-XTS Tweak prefix
> +   * Origin
> +   * Size
> +
> +The PV header contains the keys and hashes, which the UV will use to
> +decrypt and verify the PV, as well as control flags and a start PSW.
> +
> +The components are for instance an encrypted kernel, kernel cmd and

s/kernel cmd/kernel parameters/ ?

> +initrd. The components are decrypted by the UV.
> +
> +All non-decrypted data of the guest before it switches to protected
> +virtualization mode are zero on first access of the PV.

Before it switches to protected virtualization mode, all non-decrypted
data of the guest are ... ?

> +
> +When running in protected mode some subcodes will result in exceptions
> +or return error codes.
> +
> +Subcodes 4 and 7 will result in specification exceptions as they would
> +not clear out the guest memory.
> +When removing a secure VM, the UV will clear all memory, so we can't
> +have non-clearing IPL subcodes.
> +
> +Subcodes 8, 9, 10 will result in specification exceptions.
> +Re-IPL into a protected mode is only possible via a detour into non
> +protected mode.
> +
> +Keys
> +----
> +Every CEC will have a unique public key to enable tooling to build
> +encrypted images.
> +See  `s390-tools <https://github.com/ibm-s390-tools/s390-tools/>`_
> +for the tooling.
> diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kv=
m/s390-pv.rst
> new file mode 100644
> index 000000000000..dbe9110dfd1e
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv.rst
> @@ -0,0 +1,116 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +s390 (IBM Z) Ultravisor and Protected VMs
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Summary
> +-------
> +Protected virtual machines (PVM) are KVM VMs, where KVM can't access
> +the VM's state like guest memory and guest registers anymore. Instead,
> +the PVMs are mostly managed by a new entity called Ultravisor
> +(UV). The UV provides an API that can be used by PVMs and KVM to
> +request management actions.
> +
> +Each guest starts in the non-protected mode and then may make a
> +request to transition into protected mode. On transition, KVM
> +registers the guest and its VCPUs with the Ultravisor and prepares
> +everything for running it.
> +
> +The Ultravisor will secure and decrypt the guest's boot memory
> +(i.e. kernel/initrd). It will safeguard state changes like VCPU
> +starts/stops and injected interrupts while the guest is running.
> +
> +As access to the guest's state, such as the SIE state description, is
> +normally needed to be able to run a VM, some changes have been made in
> +SIE behavior. A new format 4 state description has been introduced,

s/in SIE behavior/in the behavior of the SIE instruction/ ?

> +where some fields have different meanings for a PVM. SIE exits are
> +minimized as much as possible to improve speed and reduce exposed
> +guest state.
[...]

 Thomas


