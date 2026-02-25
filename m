Return-Path: <kvm+bounces-71893-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOuECWtyn2llcAQAu9opvQ
	(envelope-from <kvm+bounces-71893-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:06:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1043019E246
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6F79B30219E3
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953B131A576;
	Wed, 25 Feb 2026 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tA+Pbm0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F37310620
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 22:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772057191; cv=none; b=Vy9hIiBbXZFw6LyPp4mM4sXYcngaDTZOnFYY4xmFfXyxJNBf+xMrXByh7cUhiEz7pb6JPHmbY6OVmrbf1FR/gHYB+/+CCesOjytChAqAQijv6acHGgns3C+whswC0glaoB+vF64B7sbcr7YCK6wC9DGfRa6gc8UfQ7w4yNrcfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772057191; c=relaxed/simple;
	bh=LJWtxfMSbjaR7UL7hdep9H/YDcNXa8SN1R3pQvw0+Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHdUj1kaStF6/iMUYijRnetVs5+V3LGU/IXiU0msUuwrkQwVojV+DHsGD/cFCFYf061bPhPt+kPSYCI4tVtwol5YawUdnvdBd6N/qetqUQTwcnx9eXGrxAWOB/rIga0Be8cMOqDf21nAaCYlIbU/kk8FMTMAmUEwAjlp9PSpumw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tA+Pbm0Y; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ada9e4ea32so11385ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 14:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772057189; x=1772661989; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKxFO5jbcj0n3yx3uCDHTRhkwPsNZ/ADjqKpvoexazc=;
        b=tA+Pbm0YWZZbEJBWS4Tr4W7PpkLvYJdLDNIcSF8/87i9oDVFj+Oz+s3bBv0r6W7PlG
         NEcFRl6QB/YdLaxiel9L3DCwLztCmQrSXxaUxtdkefuFoWFIHG3VgRMJv0nj0eSkW2AI
         /G3DvLZmmXsW7d1ZDWanlu+GBMsmI3FhtUrnRlW9tgPwglg1jugdpYuUjdwZbuj7aHK1
         CbBmH2tQ70fyIVwV+ZJtG1FEJ/z3vmGea+A/4TMAJ3ZHCx6TrHQtCxC+YVbWui3pWRu0
         jHvSqojoeLrA7wPutUbnsggmp2BfW13G/svB/7nm7sLAoLTHZsCb+8kGv34V2nIapyAp
         eF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057189; x=1772661989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKxFO5jbcj0n3yx3uCDHTRhkwPsNZ/ADjqKpvoexazc=;
        b=rYVh6ZBW++LqsWfXCIrBzsNkgDkr9sZicfLnHZJu+6+PoeU93rKiG3KQg+UVp2b6zi
         mTYWuQg59HZy1oXJvRV+RvUCTj9Felp4J+IMHuuWL3dPVYH/icNi8gRQar5Mg1WRmbdU
         jK6DL88foqlpb6H/t9AuRVznc4/1znNkKPfHC7BDsMBbwxalerYIsR1qo2CmPYOfZWxh
         2BX7/qCtztL86tntAVNTIk94i1G/X8JQ82vVBSpQ2rhH1uedIqA2VFGVmFae6iIANik0
         pR9Fevqc3oJtn8I+Ede0qoBSAutU1Z3I5M5TdUMrSUO4XBAa5xH9K1tcLOhoi2DBBiom
         YpDw==
X-Forwarded-Encrypted: i=1; AJvYcCVDuLtRkFF3rgT9YjPH5zuYXCzyxLL1R+W2gBn5JuJuHocv9vskgbo8sb2YI+Os6KhUwqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9tNFG5LXZKJR628KyIOxHXbDGoF8NRcNDIsD/LBm4z6e5UH24
	mtF1PyZdJsY4ZkrvLs6b+X3JmCQl1skal8db141WRRk8yROpRB/DIrca3MsdfDaHTA==
X-Gm-Gg: ATEYQzwwT46ktxuxbM0dPPplK3CF9DD0TJIAGttL136HI7MF7FFx6SlC8RwW5ePBz+G
	32jNSlhOxwudOeZsPDL1om+zDheVklm18OUciqfq1Za5oTvF7ueh6osCXuUetslO5GCXjrd7nGX
	yqWc0uC7F77RtO3vmZTGGx3Rk3h8GLZDRABsApDHy+cXPI2KryC97bQSRTvNkuyaCbQ4XVHSr0R
	dbykkV/grXzL6N8NAo+1Riw87eU0WFXpTl8vd/o0RPrjShkHXQgXS6rgx5LrLQnIHmRi3+HfFBF
	DoSPjM2MqLi3NMTpHD6Ga05V9LYZlJ4bO3QyxqzAcnajvRqoy06D5tRlXxdF7cLE1MKuVvukSNi
	kLbH0MgMD1alsvSyXajriLI4z+uO7Atan8XgzQP+0hXi2nZ/AIqOVcpuCPyQSfLM37mEm1XeNm+
	LhMv7y3kRgxcSg+H9vKdah8Qjdyg7t580EGHBqu79HVnn3dNUA+HK3hq3+pEFHL4g8YrnpOIQ=
X-Received: by 2002:a17:903:2a86:b0:29e:27f4:bac0 with SMTP id d9443c01a7336-2adf77c692amr672495ad.16.1772057188344;
        Wed, 25 Feb 2026 14:06:28 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a05e831sm236247b3a.58.2026.02.25.14.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:06:27 -0800 (PST)
Date: Wed, 25 Feb 2026 22:06:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	 =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ9yWlcqs2b6FLxy@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225143328.35be89f6@shazbot.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[google.com,nvidia.com,amazon.com,fb.com,linux-foundation.org,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71893-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1043019E246
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 02:33:28PM -0700, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:51 +0000
> David Matlack <dmatlack@google.com> wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 0c771064c0b8..19e88322af2c 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
> >  	int ret;
> >  	bool is_disable_vga = true;
> >  
> > +	ret = vfio_pci_liveupdate_init();
> > +	if (ret)
> > +		return ret;
> > +
> >  #ifdef CONFIG_VFIO_PCI_VGA
> >  	is_disable_vga = disable_vga;
> >  #endif
> > @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
> >  
> >  	/* Register and scan for devices */
> >  	ret = pci_register_driver(&vfio_pci_driver);
> > -	if (ret)
> > +	if (ret) {
> > +		vfio_pci_liveupdate_cleanup();
> >  		return ret;
> > +	}
> >  
> >  	vfio_pci_fill_ids();
> >  
> > @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
> >  static void __exit vfio_pci_cleanup(void)
> >  {
> >  	pci_unregister_driver(&vfio_pci_driver);
> > +	vfio_pci_liveupdate_cleanup();
> >  }
> >  module_exit(vfio_pci_cleanup);
> >  
> > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > new file mode 100644
> > index 000000000000..b84e63c0357b
> > --- /dev/null
> > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > @@ -0,0 +1,69 @@
> ...
> > +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> > +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> > +	.preserve = vfio_pci_liveupdate_preserve,
> > +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> > +	.retrieve = vfio_pci_liveupdate_retrieve,
> > +	.finish = vfio_pci_liveupdate_finish,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> > +	.ops = &vfio_pci_liveupdate_file_ops,
> > +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> > +};
> > +
> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> > +
> > +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +}
> 
> liveupdate_register_file_handler() "pins" vfio-pci with a
> try_module_get().  Since this is done in our module_init function and
> unregister occurs in our module_exit function, rather than relative
> to any actual device binding or usage, this means vfio-pci CANNOT be
> unloaded.  That seems bad.  Thanks,

Hmm... IIUC the concern here is about liveupdate policy if the user 
wants to unload a module which was previously marked for preservation?

AFAICT, In such a case, the user is expected to close the LUO session FD,
which "unpreserves" the FD. Finally, when rmmod is executed, the __exit 
(vfio_pci_cleanup) calls vfio_pci_liveupdate_cleanup() which ends up 
calling liveupdate_unregister_file_handler(), thereby dropping the ref
held by the liveupdate orchestrator which allows the module to be
unloaded.

I think we should document this policy somewhere or have a dev_warn to
scream at the users when they try unloading the module without closing
the session FD.

Thanks,
Praan

> 
> Alex
> 
> > +
> > +void vfio_pci_liveupdate_cleanup(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return;
> > +
> > +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> > +}

