Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37AE5A18E0
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 20:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243433AbiHYSjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 14:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242925AbiHYSjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 14:39:06 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F14A3D51
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:39:04 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-32a09b909f6so564564037b3.0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=B+6GHANqVGrhre1yIICjUKUVABFJYsXY9KlsXWrq0g0=;
        b=B85LgmnE6J6rXg7BVngfQTw4IEjIKrGKdqIeDIjR3AWtFqojLHLJcIFpUb/kio7nLp
         Q+Ui7InM8EeA6fFs7Ovf0/ZosbdTVjCy7D8cMlV6fDhzod2KJN/4nk9mVhQ0FZQbE+Ky
         QstKO/uftXpVDD4tBNkWiPAMtu3ZT8/ej/ZSvGUcLEWZFY0lt12Otkn4bzRlVnhh1rx6
         v1MWHoVRbsz20H7ZjCC6iSK7MQfC7xupNt5YGgKQ0K9Dy210qTIgMkNTvPpIjL3nfH+N
         uZ86ViMYJrB57R5lrqCVZJvZgKRj3BRPaPN1gFz3nUQyy9V9YzX1BsykChMTGDUfqP+t
         jUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=B+6GHANqVGrhre1yIICjUKUVABFJYsXY9KlsXWrq0g0=;
        b=nyhpHQkFeTXWo0e/3nJHO1KX3nkDT+OTRYZ6lpmZasm1QXrlyErxDRgqI5PySk+A7S
         URJSHrA0UW325eGOq1QhjvAjZvbwgxB1LEF3IKSk2jZ4bt+APuNGGfhBhbIuCcS5M3tB
         l1pRLd5ZXjkvBqqCeiLb2AhIeaWfY8yqnCHl9ZtPSMCTrfmDjDnIOeyBUyOqKiMWs2vy
         GKElEH35Ed9EeOed71adKfXBZcjx/vamLPvyyraoEalbY5CAqNRAkt3l0k6YSF+ExVBO
         XQek0cGaAX8Kpx5vVlZMP+/tmdhnp3Lr3cyQKq6MYIWs1OSrHCtpNlYYMSRj0DeblUG1
         5JPQ==
X-Gm-Message-State: ACgBeo1DcpFCDkHkm76ixOUXhpENptD2I4fdAkQL1CH7htXGFIJwNEN7
        /JNHmFVS4VtN93DZ81EA6ByrFBASI6ZTJFY7wg0nyg==
X-Google-Smtp-Source: AA6agR7rapIlRr0/fCZEKhWKbo6XO2p0rUFCMJJnqLNETdiYbschnHcx4RcKE15j7E+GKxzg5bqk9rgOYhmm6A46bj4=
X-Received: by 2002:a25:94b:0:b0:68f:4e05:e8f0 with SMTP id
 u11-20020a25094b000000b0068f4e05e8f0mr4506829ybm.115.1661452743474; Thu, 25
 Aug 2022 11:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com> <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com> <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com> <20220824233122.GA4068@nvidia.com>
In-Reply-To: <20220824233122.GA4068@nvidia.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 25 Aug 2022 11:38:27 -0700
Message-ID: <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Aug 24, 2022 at 02:11:48PM +0200, Greg KH wrote:
> > > We can share the RFC in case you are interested in looking at code flow
> > > using the of_dynamic approach.
> >
> > Please no more abuse of the platform device.
>
> Last time this came up there was some disagreement from the ARM folks,
> they were not keen on having xx_drivers added all over the place to
> support the same OF/DT devices just discovered in a different way. It is
> why ACPI is mapped to platform_device even in some cases.
>
> I think if you push them down this path they will get resistance to
> get the needed additional xx_drivers into the needed places.
>
> > If your device can be discovered by scanning a bus, it is not a platform
> > device.
>
> A DT fragment loaded during boot binds a driver using a
> platform_driver, why should a DT fragment loaded post-boot bind using
> an XX_driver and further why should the CDX way of getting the DT
> raise to such importantance that it gets its own cdx_driver ?
>
> In the end the driver does not care about how the DT was loaded.
> None of these things are on a discoverable bus in any sense like PCI
> or otherwise. They are devices described by a DT fragement and they
> take all their parameters from that chunk of DT.
>
> How the DT was loaded into the system is not a useful distinction that
> raises the level of needing an entire new set of xx_driver structs all
> over the tree, IMHO.

Jason, I see your point or rather the point the ARM folks might have
made. But in this case, why not use DT overlays to add these devices?
IIRC there's an in kernel API to add DT overlays. If so, should this
be more of a FPGA driver that reads FPGA stuff and adds DT overlays?
That'd at least make a stronger case for why this isn't a separate
bus.


-Saravana
