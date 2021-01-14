Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EA32F5E78
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbhANKOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:14:12 -0500
Received: from 8.mo51.mail-out.ovh.net ([46.105.45.231]:46432 "EHLO
        8.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbhANKOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 05:14:12 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2021 05:14:10 EST
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.114])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id AD25625A6C9;
        Thu, 14 Jan 2021 11:07:28 +0100 (CET)
Received: from kaod.org (37.59.142.103) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 14 Jan
 2021 11:07:27 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-103G005a3ce3b89-2be7-4dd6-a28b-2751e61105ee,
                    0A7C53367AF3A9CD096E542ECC3C8B2C2D100868) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 82.253.208.248
Date:   Thu, 14 Jan 2021 11:07:26 +0100
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     <brijesh.singh@amd.com>, <pair@us.ibm.com>, <dgilbert@redhat.com>,
        <pasic@linux.ibm.com>, <qemu-devel@nongnu.org>,
        <cohuck@redhat.com>,
        "Richard Henderson" <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, <borntraeger@de.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <mst@redhat.com>,
        <jun.nakajima@intel.com>, <thuth@redhat.com>,
        <pragyansri.pathi@intel.com>, <kvm@vger.kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>, <qemu-s390x@nongnu.org>,
        <qemu-ppc@nongnu.org>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>, <andi.kleen@intel.com>
Subject: Re: [PATCH v7 09/13] confidential guest support: Update
 documentation
Message-ID: <20210114110726.189ee7fa@bahia.lan>
In-Reply-To: <20210113235811.1909610-10-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-10-david@gibson.dropbear.id.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 482ab6a6-6e0e-4269-8191-07b76130d318
X-Ovh-Tracer-Id: 1720375058512583068
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedukedrtdehgddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepfedutdeijeejveehkeeileetgfelteekteehtedtieefffevhffflefftdefleejnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegrnhguihdrkhhlvggvnhesihhnthgvlhdrtghomh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:07 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Now that we've implemented a generic machine option for configuring various
> confidential guest support mechanisms:
>   1. Update docs/amd-memory-encryption.txt to reference this rather than
>      the earlier SEV specific option
>   2. Add a docs/confidential-guest-support.txt to cover the generalities of
>      the confidential guest support scheme
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---

LGTM

Reviewed-by: Greg Kurz <groug@kaod.org>

>  docs/amd-memory-encryption.txt      |  2 +-
>  docs/confidential-guest-support.txt | 43 +++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 docs/confidential-guest-support.txt
> 
> diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> index 80b8eb00e9..145896aec7 100644
> --- a/docs/amd-memory-encryption.txt
> +++ b/docs/amd-memory-encryption.txt
> @@ -73,7 +73,7 @@ complete flow chart.
>  To launch a SEV guest
>  
>  # ${QEMU} \
> -    -machine ...,memory-encryption=sev0 \
> +    -machine ...,confidential-guest-support=sev0 \
>      -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
>  
>  Debugging
> diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
> new file mode 100644
> index 0000000000..2790425b38
> --- /dev/null
> +++ b/docs/confidential-guest-support.txt
> @@ -0,0 +1,43 @@
> +Confidential Guest Support
> +==========================
> +
> +Traditionally, hypervisors such as qemu have complete access to a
> +guest's memory and other state, meaning that a compromised hypervisor
> +can compromise any of its guests.  A number of platforms have added
> +mechanisms in hardware and/or firmware which give guests at least some
> +protection from a compromised hypervisor.  This is obviously
> +especially desirable for public cloud environments.
> +
> +These mechanisms have different names and different modes of
> +operation, but are often referred to as Secure Guests or Confidential
> +Guests.  We use the term "Confidential Guest Support" to distinguish
> +this from other aspects of guest security (such as security against
> +attacks from other guests, or from network sources).
> +
> +Running a Confidential Guest
> +----------------------------
> +
> +To run a confidential guest you need to add two command line parameters:
> +
> +1. Use "-object" to create a "confidential guest support" object.  The
> +   type and parameters will vary with the specific mechanism to be
> +   used
> +2. Set the "confidential-guest-support" machine parameter to the ID of
> +   the object from (1).
> +
> +Example (for AMD SEV)::
> +
> +    qemu-system-x86_64 \
> +        <other parameters> \
> +        -machine ...,confidential-guest-support=sev0 \
> +        -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
> +
> +Supported mechanisms
> +--------------------
> +
> +Currently supported confidential guest mechanisms are:
> +
> +AMD Secure Encrypted Virtualization (SEV)
> +    docs/amd-memory-encryption.txt
> +
> +Other mechanisms may be supported in future.

