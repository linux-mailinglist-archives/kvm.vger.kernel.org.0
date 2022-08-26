Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D15A2421
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbiHZJTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 05:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245702AbiHZJTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 05:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B61089
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 02:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661505585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cm8RaaQOEoWRKPJuTt0OE6ZMdykOljvLPHXmg6dBM3U=;
        b=FfSoz4krvuwePAdaI5Pk07KjJyCYntkLY0LNZpTaUocY0TP0GBzPi1golobaAPAA162Rbs
        1d/tpmRIdzEW2KBgNnojJ2KIv00Bgkg5P/a/7wi26Nsi3R5zAo3cFY5kMVVpJDTlhJjAvj
        +Fy6dw/VJ1tTOybLzhR2sZXdFlP6DhE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-h2vrZDoKOCmFWuwSJ6fImA-1; Fri, 26 Aug 2022 05:19:42 -0400
X-MC-Unique: h2vrZDoKOCmFWuwSJ6fImA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B70691C00AC3;
        Fri, 26 Aug 2022 09:19:41 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 653E5C15BBA;
        Fri, 26 Aug 2022 09:19:41 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id A34211800627; Fri, 26 Aug 2022 11:19:39 +0200 (CEST)
Date:   Fri, 26 Aug 2022 11:19:39 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [PATCH v1 26/40] headers: Add definitions from UEFI spec for
 volumes, resources, etc...
Message-ID: <20220826091939.hqvgkoariygt7px5@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-27-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-27-xiaoyao.li@intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:36PM +0800, Xiaoyao Li wrote:
> Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
> will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
> to the Trusted Domain Virtual Firmware (TDVF).
> 
> All values come from the UEFI specification and TDVF design guide. [1]
> 
> Note, EFI_RESOURCE_MEMORY_UNACCEPTED will be added in future UEFI spec.
> 
> [1] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Acked-by: Gerd Hoffmann <kraxel@redhat.com>

