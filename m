Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2CE7825F1
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbjHUJAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjHUJAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F5CF
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692608393;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=oUNFPBwuacrfKR5wY4zXtbeCoielBgq1hU50/mf0WdI=;
        b=gZ3BiUr20yjvQXTgPYKQ3M8PmrUKeIYnFuxNoqqkaMTX3mFnUGfmfY5vW0ZViIkdEzxfl+
        YkFviCeidGqVtJ9HgVKvwrLet6wbjvQTIlu64uLDePluxeqjHR20G6/MTdi2WNR6RSoNLl
        zQ1v13+TB/vs0B/EHzIW3RxrGlDNeqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-kUh68BOcP_y6u4hycSuLmg-1; Mon, 21 Aug 2023 04:59:51 -0400
X-MC-Unique: kUh68BOcP_y6u4hycSuLmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B59BA185A78B;
        Mon, 21 Aug 2023 08:59:50 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41B7B40D2843;
        Mon, 21 Aug 2023 08:59:46 +0000 (UTC)
Date:   Mon, 21 Aug 2023 09:59:43 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 15/58] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <ZOMnf8n8BksktlGg@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-16-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-16-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:49:58AM -0400, Xiaoyao Li wrote:
> Bit 28 of TD attribute, named SEPT_VE_DISABLE. When set to 1, it disables
> EPT violation conversion to #VE on guest TD access of PENDING pages.
> 
> Some guest OS (e.g., Linux TD guest) may require this bit as 1.
> Otherwise refuse to boot.
> 
> Add sept-ve-disable property for tdx-guest object, for user to configure
> this bit.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  qapi/qom.json         |  4 +++-
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 2ca7ce7c0da5..cc08b9a98df9 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -871,10 +871,12 @@
>  #
>  # Properties for tdx-guest objects.
>  #
> +# @sept-ve-disable: bit 28 of TD attributes (default: 0)

This description isn't very useful as it forces the user to go off and
read the TDX specification to find out what bit 28 means. You've got a
more useful description in the commit message, so please use that
in the docs too. eg something like this

  @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
                    of EPT violation conversion to #VE on guest
                    TD access of PENDING pages. Some guest OS (e.g.
		    Linux TD guest) may require this set, otherwise
                    they refuse to boot.

> +#
>  # Since: 8.2
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { }}
> +  'data': { '*sept-ve-disable': 'bool' } }
>  
>  ##
>  # @ThreadContextProperties:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 3d313ed46bd1..22130382c0c5 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -32,6 +32,8 @@
>                                       (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
>                                       (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
>  
> +#define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
> +
>  #define TDX_ATTRIBUTES_MAX_BITS      64
>  
>  static FeatureMask tdx_attrs_ctrl_fields[TDX_ATTRIBUTES_MAX_BITS] = {
> @@ -501,6 +503,24 @@ out:
>      return r;
>  }
>  
> +static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    return !!(tdx->attributes & TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE);
> +}
> +
> +static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
> +{
> +    TdxGuest *tdx = TDX_GUEST(obj);
> +
> +    if (value) {
> +        tdx->attributes |= TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
> +    } else {
> +        tdx->attributes &= ~TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
> +    }
> +}
> +
>  /* tdx guest */
>  OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>                                     tdx_guest,
> @@ -516,6 +536,10 @@ static void tdx_guest_init(Object *obj)
>      qemu_mutex_init(&tdx->lock);
>  
>      tdx->attributes = 0;
> +
> +    object_property_add_bool(obj, "sept-ve-disable",
> +                             tdx_guest_get_sept_ve_disable,
> +                             tdx_guest_set_sept_ve_disable);
>  }
>  
>  static void tdx_guest_finalize(Object *obj)
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

