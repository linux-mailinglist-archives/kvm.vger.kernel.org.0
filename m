Return-Path: <kvm+bounces-1835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA2B7EC9B6
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 18:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E33E1F240D1
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 17:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD741210;
	Wed, 15 Nov 2023 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CAcrLfQX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B762E1BC
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700069564;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=Uzt1H6IiduWoOESS5yb5Ah/q4IbGU14f7YGIACpeHuY=;
	b=CAcrLfQXuz2jnQ+fNnar1/Njr2dlBcSEVfh+sNop9yILM7OFxXrfik+xp52mdmjhAM20as
	XL3q727o3dY1FA/5IOvh7Ig3kE6PAVnT47jf6Fv4+/z8LdBOF1YYilQNJJlZ+SJI7L1+nJ
	bz6LcaLgJHDZ7tDwHxfuGXiFCRN53Ag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-YgyaIgBJOeaNWGWxwCttXA-1; Wed, 15 Nov 2023 12:32:41 -0500
X-MC-Unique: YgyaIgBJOeaNWGWxwCttXA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD8EF85A58A;
	Wed, 15 Nov 2023 17:32:40 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FF885031;
	Wed, 15 Nov 2023 17:32:35 +0000 (UTC)
Date: Wed, 15 Nov 2023 17:32:33 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 31/70] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Message-ID: <ZVUAsQXeN7i4cRmS@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-32-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-32-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Nov 15, 2023 at 02:14:40AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
> can be provided for TDX attestation.
> 
> So far they were hard coded as 0. Now allow user to specify those values
> via property mrconfigid, mrowner and mrownerconfig. They are all in
> base64 format.
> 
> example
> -object tdx-guest, \
>   mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>   mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
>  - use base64 encoding instread of hex-string;
> ---
>  qapi/qom.json         | 11 +++++-
>  target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  3 ++
>  3 files changed, 98 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 3a29659e0155..fd99aa1ff8cc 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -888,10 +888,19 @@
>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>  #     be set, otherwise they refuse to boot.
>  #
> +# @mrconfigid: base64 encoded MRCONFIGID SHA384 digest
> +#
> +# @mrowner: base64 encoded MROWNER SHA384 digest
> +#
> +# @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
> +#
>  # Since: 8.2
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*sept-ve-disable': 'bool' } }
> +  'data': { '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }
>  
>  ##
>  # @ThreadContextProperties:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 28b3c2765c86..b70efbcab738 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -13,6 +13,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "qemu/error-report.h"
> +#include "qemu/base64.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
>  #include "standard-headers/asm-x86/kvm_para.h"
> @@ -508,6 +509,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      X86CPU *x86cpu = X86_CPU(cpu);
>      CPUX86State *env = &x86cpu->env;
>      struct kvm_tdx_init_vm *init_vm;
> +    uint8_t *data;
> +    size_t data_len;

Don't declare these here.

>      int r = 0;
>  
>      qemu_mutex_lock(&tdx_guest->lock);
> @@ -518,6 +521,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>                          sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>  
> +#define SHA384_DIGEST_SIZE  48
> +
> +    if (tdx_guest->mrconfigid) {

> +        data = qbase64_decode(tdx_guest->mrconfigid,
> +                              strlen(tdx_guest->mrconfigid), &data_len, errp);

Declare it here:

    g_autofree uint8_t *data = qbase64_decode(...)


so we aviod the memory leak of 'data' in each if()... block


> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrconfigid");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrconfigid, data, data_len);
> +    }
> +
> +    if (tdx_guest->mrowner) {
> +        data = qbase64_decode(tdx_guest->mrowner,
> +                              strlen(tdx_guest->mrowner), &data_len, errp);
> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrowner");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrowner, data, data_len);
> +    }
> +
> +    if (tdx_guest->mrownerconfig) {
> +        data = qbase64_decode(tdx_guest->mrownerconfig,
> +                              strlen(tdx_guest->mrownerconfig), &data_len, errp);
> +        if (!data || data_len != SHA384_DIGEST_SIZE) {
> +            error_setg(errp, "TDX: failed to decode mrownerconfig");
> +            return -1;
> +        }
> +        memcpy(init_vm->mrownerconfig, data, data_len);
> +    }
> +
>      r = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPUS, 0, ms->smp.cpus);
>      if (r < 0) {
>          error_setg(errp, "Unable to set MAX VCPUS to %d", ms->smp.cpus);
> @@ -567,6 +602,48 @@ static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
>      }
>  }
> +static void tdx_guest_set_mrconfigid(Object *obj, const char *value, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    tdx->mrconfigid = g_strdup(value);
> +}

g_free(tdx->mrconfigid) first to be sure we don't leak if
the value is set twice.

> +
> +static char * tdx_guest_get_mrowner(Object *obj, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    return g_strdup(tdx->mrowner);
> +}
> +
> +static void tdx_guest_set_mrowner(Object *obj, const char *value, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    tdx->mrconfigid = g_strdup(value);
> +}
> +
> +static char * tdx_guest_get_mrownerconfig(Object *obj, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    return g_strdup(tdx->mrownerconfig);
> +}
> +
> +static void tdx_guest_set_mrownerconfig(Object *obj, const char *value, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    tdx->mrconfigid = g_strdup(value);
> +}
> +
>  /* tdx guest */
>  OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>                                     tdx_guest,
> @@ -586,6 +663,14 @@ static void tdx_guest_init(Object *obj)
>      object_property_add_bool(obj, "sept-ve-disable",
>                               tdx_guest_get_sept_ve_disable,
>                               tdx_guest_set_sept_ve_disable);
> +    object_property_add_str(obj, "mrconfigid",
> +                            tdx_guest_get_mrconfigid,
> +                            tdx_guest_set_mrconfigid);
> +    object_property_add_str(obj, "mrowner",
> +                            tdx_guest_get_mrowner, tdx_guest_set_mrowner);
> +    object_property_add_str(obj, "mrownerconfig",
> +                            tdx_guest_get_mrownerconfig,
> +                            tdx_guest_set_mrownerconfig);
>  }
>  
>  static void tdx_guest_finalize(Object *obj)
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index 432077723ac5..6e39ef3bac13 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -21,6 +21,9 @@ typedef struct TdxGuest {
>  
>      bool initialized;
>      uint64_t attributes;    /* TD attributes */
> +    char *mrconfigid;       /* base64 encoded sha348 digest */
> +    char *mrowner;          /* base64 encoded sha348 digest */
> +    char *mrownerconfig;    /* base64 encoded sha348 digest */
>  } TdxGuest;
>  
>  #ifdef CONFIG_TDX
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


