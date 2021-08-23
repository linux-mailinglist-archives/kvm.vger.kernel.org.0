Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5C3F4D2E
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 17:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhHWPRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 11:17:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230399AbhHWPRM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 11:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629731789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN1b/ZryAIDQdlT9EYOFyEAWtXpqjUmEBD/b/C3QFkQ=;
        b=CdbPIEq3nX11WfwPTN6qcUKfceqMaA4jAW8mbp+gXioAFLhzH2IS6x+YhppjOXxV+5+0Rl
        6r3bPQotegA3ZCGShJSb7uUCrulJru3xvKXGm8o47bfOtbTVxFxhWnCc6SVUl3dKUp+OET
        lmZ0/4idaRa8Ds4rm9VPnfbxoSodXkI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-50VtS4RXNaeToKu7NO8WoA-1; Mon, 23 Aug 2021 11:16:27 -0400
X-MC-Unique: 50VtS4RXNaeToKu7NO8WoA-1
Received: by mail-ot1-f72.google.com with SMTP id m32-20020a9d1d230000b02905103208125aso10225360otm.3
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 08:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DN1b/ZryAIDQdlT9EYOFyEAWtXpqjUmEBD/b/C3QFkQ=;
        b=DqAT8GQdgOmvGdPvLyQZ3rt/r92hoOOtepI9LEcTzkMXlNfPbdD1YfMMbutErU45Fd
         fZ/ksurTZ/7Qxsw0iFCG4uxUSPTs4aSaDKRliWA5QaQV2IsrXXbbdkfs5tq8le4okK4f
         Lr+F6aQsBkKdNrpaA364/8ekEHJNRN8u44GytVXqbNJh5PA9CMbNweBozGbtBVsXEQVm
         PAwRhAb/wbAyJAQ9lIk9sCy+Al9J1Sm7oyg1C9kKvjMuO3M4lsSErS0Fy6jJw5C+QySy
         XsapKKcP4lIu1rmn2WvhqioXD7OWLwPzsYQX781KgfiR/XU9m2SqqgSKnt6a4LchgaE0
         hLaQ==
X-Gm-Message-State: AOAM530c6XShOoHmqieC3z3nFlZJ5e2I+9DUYSQ4Y1zSh837S5Hasi0Y
        AQi2ljDmpduEyFYwkhVzh9SQVEdz/+wMXMSoHC+S7/3qkQQn2ssj7kyph7oKh+m4l4oTyi1p+ov
        LKcVtNawlY30Q
X-Received: by 2002:a05:6830:1dac:: with SMTP id z12mr24543868oti.52.1629731787081;
        Mon, 23 Aug 2021 08:16:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqOeF/H0qDGnn9D02GiZCSA4DRcSR8LiSLGylhEba8t1EsbxXzTz8dIto+iigT90XxNROCzg==
X-Received: by 2002:a05:6830:1dac:: with SMTP id z12mr24543850oti.52.1629731786895;
        Mon, 23 Aug 2021 08:16:26 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id x1sm2557766otu.8.2021.08.23.08.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:16:26 -0700 (PDT)
Date:   Mon, 23 Aug 2021 09:16:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <diana.craciun@oss.nxp.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <masahiroy@kernel.org>,
        <michal.lkml@markovi.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mgurtovoy@nvidia.com>, <jgg@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: Re: [PATCH V3 06/13] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
Message-ID: <20210823091624.697c67d6.alex.williamson@redhat.com>
In-Reply-To: <20210822143602.153816-7-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
        <20210822143602.153816-7-yishaih@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 17:35:55 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> new file mode 100644
> index 000000000000..15474ebadd98
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci.c
...
> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> +{
> +	might_sleep();
> +
> +	if (!enable_sriov)
> +		return -ENOENT;
> +
> +	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
> +}

As noted in previous version, why do we need the might_sleep() above
when the core code below includes it and there's nothing above that
might sleep before that?  Thanks,

Alex

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 94f062818e0c..87d1960d0d61 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
...
> -static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> +int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  {
>  	struct vfio_device *device;
>  	int ret = 0;
>  
>  	might_sleep();
>  
> -	if (!enable_sriov)
> -		return -ENOENT;
> -
>  	device = vfio_device_get_from_dev(&pdev->dev);
>  	if (!device)
>  		return -ENODEV;

