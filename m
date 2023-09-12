Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EA279C6D3
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 08:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjILGTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 02:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjILGTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 02:19:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC24AF
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 23:19:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-307d20548adso5285368f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 23:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694499582; x=1695104382; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=as0zlTcAP4J2MB9rRCswsecCRWJqSb1a7pVuVyDfTro=;
        b=B64avlJmmD8gfTeBn7Yzti3JUTOvpJK2wP5ij8JzAmihcOfLId5R0c4QR2N9D3n5BO
         cUmQVh1mNxoQ5c4bIAXRx+YOiIQHJCrbCsY2UKAKHrELcHbh4lGGGh3SMigzuNZ96O3y
         Mq1trK9OfJboHbf6osoU8zoh5xRBCujtG5UsuUT85ufRaUhl81oVjEHzcw9c8BF1qli+
         /iYzuxuiZ8qOck3eblI+bKq7LXPwFFBSKnWpJ1kjvei7YbSojOs1/fsoGxV47Ld0C8iY
         eK3dr6MDAIrNSnVhtExKTv/rmG8szDyfFazqu9TfkSaB8F7ju2X5E0IAZu9zR0OqT77L
         zpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694499582; x=1695104382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=as0zlTcAP4J2MB9rRCswsecCRWJqSb1a7pVuVyDfTro=;
        b=Nmj1vQ8vdYm2sI2Pac63iXMeBHrQu+/nkVFzF437RVX0X7F3ePwP+AnGyPzJv5xDH2
         RzyZ1gsU1g1OYczndPYE4qMU29fR+q7KTC6wUqMm3MzjT8ce2/XgCnobn1esgCytN+b0
         qwEemNfLWdOIzVYal5hOg2mOPRJ9cf6KuxxudRDmYGYzXoR0uag3dnaT+8zgqX6eZOoc
         AQgA92g+YB1IGvrJwivTUo3UwVm62E5FV55p5TPEXWyL+RCTDylo4l5KeCETdtHwh3qy
         AGjbY4Xrhe6o14ShFlaP+TP2wSc8Kx4JY4nb4yQP9C7R/jJECxpO9DELypj5KPdm4vE6
         XmyQ==
X-Gm-Message-State: AOJu0YyrPN//lGotBWZ1jGRYb8ieeXFlaW/iCp0Qq5JAOCacnbvZt5A5
        lnlOuFwKpclayMy6sN8WK5DDOB/R0SZX2RuphSc=
X-Google-Smtp-Source: AGHT+IEKKNFf3/Ej1BIaCOo+qCIfpdIJ+Cm6Q+CkG1HkhgRHobEna6dhMx+YLMB4T+eQGb1ASHoPEQ==
X-Received: by 2002:a5d:694c:0:b0:316:f25c:d0b3 with SMTP id r12-20020a5d694c000000b00316f25cd0b3mr8997872wrw.22.1694499582150;
        Mon, 11 Sep 2023 23:19:42 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v4-20020adfedc4000000b003179d7ed4f3sm11901995wro.12.2023.09.11.23.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 23:19:41 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:19:38 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     brett.creeley@amd.com, kvm@vger.kernel.org
Subject: Re: [bug report] vfio/pds: Add VFIO live migration support
Message-ID: <d300eaea-4d7e-411b-845c-2caa83232c73@kadam.mountain>
References: <1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain>
 <1a52e623-9270-1c2e-7c21-2be5b94e433b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a52e623-9270-1c2e-7c21-2be5b94e433b@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 09:03:57AM -0700, Brett Creeley wrote:
> On 9/11/2023 7:24 AM, Dan Carpenter wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > Hello Brett Creeley,
> > 
> > The patch bb500dbe2ac6: "vfio/pds: Add VFIO live migration support"
> > from Aug 7, 2023 (linux-next), leads to the following Smatch static
> > checker warning:
> > 
> >          drivers/vfio/pci/pds/lm.c:117 pds_vfio_put_save_file()
> >          warn: sleeping in atomic context
> > 
> > The call tree is:
> > 
> > pds_vfio_state_mutex_unlock() <- disables preempt
> > -> pds_vfio_put_save_file() <- sleeps
> > 
> > drivers/vfio/pci/pds/vfio_dev.c
> >      29  void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
> >      30  {
> >      31  again:
> >      32          spin_lock(&pds_vfio->reset_lock);
> >                  ^^^^^^^^^
> > Preempt disabled
> > 
> >      33          if (pds_vfio->deferred_reset) {
> >      34                  pds_vfio->deferred_reset = false;
> >      35                  if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
> >      36                          pds_vfio_put_restore_file(pds_vfio);
> >      37                          pds_vfio_put_save_file(pds_vfio);
> >                                  ^^^^^^^^^^^^^^^^^^^^^^
> > 
> >      38                          pds_vfio_dirty_disable(pds_vfio, false);
> >      39                  }
> >      40                  pds_vfio->state = pds_vfio->deferred_reset_state;
> >      41                  pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
> >      42                  spin_unlock(&pds_vfio->reset_lock);
> >      43                  goto again;
> >      44          }
> >      45          mutex_unlock(&pds_vfio->state_mutex);
> >      46          spin_unlock(&pds_vfio->reset_lock);
> > 
> > Unrelated but it really makes me itch that we drop the mutex before the
> > spinlock.
> 
> This was done based on Mellanox's implementation and there's some
> history/notes on where this came from.
> 
> AFAIK these are the relevant pointers for the original discussion and a code
> comment as well:
> 
> Original thread:
> https://lore.kernel.org/netdev/20211019105838.227569-8-yishaih@nvidia.com/T/
> 
> Also, there is a comment in drivers/vfio/pci/mlx5/main.c inside of
> mlx5vf_pci_aer_reset_done().
> 
> Maybe it would be best to add a comment in pds_vfio_reset() as well?

Nah.  It's fine.  Or we could just add a comment like:
/* see mlx5vf_pci_aer_reset_done() to understand the lock ordering */

regards,
dan carpenter

