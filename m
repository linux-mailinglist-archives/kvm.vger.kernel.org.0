Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70838774A0B
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjHHUNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbjHHUMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:12:48 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E9C35C63
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:43:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2693640dfa2so1975822a91.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691520209; x=1692125009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e5Kq1LJc+7Xua2Kq4jL8Y3azeq9CaYf9ma2OpUQOoes=;
        b=be1D7x5HcJqbJr27O9QIV9joDE3vudd1QIP8F4Qgp4v2bIvgL98wvF67K8ptum1zM2
         rVcVlh0E9HVHGLUq0+J8M8cOP1JhiobRwtXpij1/CVCLwuDLT7bzIzY2/aOD4ne8lf9k
         7pCgsClRPSqKYWjp5s9RKFzKoygpeelVphLGe1NAcNrjZL98IrObDkQ9HoPqTSAqn/Nx
         R+a48BRECFN1JYwlMmbLUgBF7Ux/Z4kpdO3jWANdx5bINZyb6UQkvIzVR8lyDgalWF+Q
         rBZ6jyci9piCzF3KNNqc7ARsHaNSlDYNmR1odClyIV95XJDZ/zmL6NWmvkQMrzYdgbiK
         wOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691520209; x=1692125009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5Kq1LJc+7Xua2Kq4jL8Y3azeq9CaYf9ma2OpUQOoes=;
        b=YDg3mS/nKhaMWxSEjRNtJnmSstgKLMjXJdWKNtsDTXeGZln3/aAiHJYNKR30u8xIqZ
         kynGfmMqYBHyRzlTvPJPqvgIFdzTaQ/RxissEx6yACbvW2JrCHVMLo9ANFuQzc/ifG5z
         idEhAkEdjWkA0oTPRK2M9FOdmWkLTX4+Qvu/3I06l5SRHYtdKO4CvC3YW+kqlcU+xaYD
         WTxLP9Lm52jIGmuHGZZxbUCrvtQvPt8sffBQroadjOsBOSCJtgx9vTP3bN31geOOAjGa
         Rv9shyc3/5fKyT+RhWXOBxD2+eLcbBTjWbjlsBaUWjv4wa2n2i3aasXlCHz8xrjLwROs
         XaVg==
X-Gm-Message-State: AOJu0Yw7K5MZGsvqZ4Y9jWVeIbzI2arWwtHGkGufC9g9V55wiP6MlIPu
        REXtEUjX/4JbTtc9CgVv8wfEvg==
X-Google-Smtp-Source: AGHT+IHMidDa+dRb7HS7nG66MhLisCldZm3VtChaKhwOxTTpgz5v3DNltRI6Cf7yDaiggZ/Zf9vhpw==
X-Received: by 2002:a17:90a:7e12:b0:25e:d303:b710 with SMTP id i18-20020a17090a7e1200b0025ed303b710mr329838pjl.35.1691520209601;
        Tue, 08 Aug 2023 11:43:29 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id n7-20020a17090a394700b0025c1cfdb93esm8968536pjf.13.2023.08.08.11.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 11:43:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTRfz-004vcj-KZ;
        Tue, 08 Aug 2023 15:43:27 -0300
Date:   Tue, 8 Aug 2023 15:43:27 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Message-ID: <ZNKMz04uhzL9T7ya@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:

> Is there plan to introduce further error in the future? otherwise this should
> be void.
> 
> btw the work queue is only for sva. If there is no other caller this can be
> just kept in iommu-sva.c. No need to create a helper.

I think more than just SVA will need a work queue context to process
their faults.

Jason
