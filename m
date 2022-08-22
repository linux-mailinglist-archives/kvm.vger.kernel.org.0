Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95BF59BC8D
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 11:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiHVJQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 05:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiHVJPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 05:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AA82AE34
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 02:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661159691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D8PX8VGV+zxa485SufkBq+IWwGWuDtC3c/GfFCmctrA=;
        b=TwEiBYTC/Q+1fGB7kM6sj1SNC1l90ZpCPZq0dr6uxVwZ/PcDqCXNiZm66XV5WXf2Ovss5w
        ekUDMTaHEh3ku+NuABnlkn/8lmZsfJ49hFE68kOTBsiBlFvuYI1Rv9gCyllSNcw3jztfls
        zPpb4hbJQAbvJsvQ7AphzMIJg4T/TP8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-IKkzy2GiPiOmwXPFZyABEQ-1; Mon, 22 Aug 2022 05:14:40 -0400
X-MC-Unique: IKkzy2GiPiOmwXPFZyABEQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56D341C13941;
        Mon, 22 Aug 2022 09:14:40 +0000 (UTC)
Received: from localhost (unknown [10.39.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCF19492C3B;
        Mon, 22 Aug 2022 09:14:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/fsl-mc: Fix a typo in a comment
In-Reply-To: <Yvuy/qUwU7StueDV@ziepe.ca>
Organization: Red Hat GmbH
References: <2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr>
 <YvKJTKYv2htxM1n/@ziepe.ca>
 <db505c50-e855-5e94-1f09-173310177bda@wanadoo.fr>
 <Yvuy/qUwU7StueDV@ziepe.ca>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 22 Aug 2022 11:14:38 +0200
Message-ID: <871qt8prlt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16 2022, Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Aug 16, 2022 at 05:00:50PM +0200, Christophe JAILLET wrote:
>> Le 09/08/2022 =C3=A0 18:20, Jason Gunthorpe a =C3=A9crit=C2=A0:
>> > On Sat, Aug 06, 2022 at 09:56:13PM +0200, Christophe JAILLET wrote:
>> > > L and S are swapped/
>> > > s/VFIO_FLS_MC/VFIO_FSL_MC/
>> > >=20
>> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> > > ---
>> > > All the dev_ logging functions in the file have the "VFIO_FSL_MC: "
>> > > prefix.
>> > > As they are dev_ function, the driver should already be displayed.
>> > >=20
>> > > So, does it make sense or could they be all removed?
>> > > ---
>> > >   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
>> > >   1 file changed, 1 insertion(+), 1 deletion(-)
>> > >=20
>> > > diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc=
/vfio_fsl_mc.c
>> > > index 3feff729f3ce..66d01db1d240 100644
>> > > --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> > > +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> > > @@ -110,7 +110,7 @@ static void vfio_fsl_mc_close_device(struct vfio=
_device *core_vdev)
>> > >   	if (WARN_ON(ret))
>> > >   		dev_warn(&mc_cont->dev,
>> > > -			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
>> > > +			 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
>> >=20
>> > WARN_ON already prints, this is better written as
>> >=20
>> > WARN(ret, "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
>>=20
>> Or maybe, just:
>> if (ret)
>> 	dev_warn(&mc_cont->dev,
>> 		 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
>>=20
>> This keep information about the device, avoid the duplicate printing rel=
ated
>> to WARN_ON+dev_warn and is more in line with error handling in other fil=
es.
>>=20
>> Do you agree or do you prefer a v2 as you proposed with WARN()?
>
> If the original author wrote WARN I would not degrade it to just a
> dev_warn.

Having to decide between losing the WARN and losing the device info, I'd
just... fix the typo :)

