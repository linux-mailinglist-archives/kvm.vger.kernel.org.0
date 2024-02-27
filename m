Return-Path: <kvm+bounces-10044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8698A868CB8
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20291C216AB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549E0137C20;
	Tue, 27 Feb 2024 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnqLUCUl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEFD135A68
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709027698; cv=none; b=pPudNv9OritWYVgpHNQatjzU3putNGuFCI/j4BkTKsgfdY6dXn6MU2HSQp6MMxyCJhnbbEjTKmEmk4T5b6FfIXJBunbOYJtrWkPxislMZJmtZyRjuGT35QrOQXj64+nh4Ktm+3zeugcVmwcpBUjKw1iwrRQ5Dt2LIg/UJELlFxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709027698; c=relaxed/simple;
	bh=Zk7o7sUzRba0JQK3Ym72GL+cw8hLT3hXk9Ws635mKEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSkG4BuQnJOvKOwfr/68iDUsaVWjpYYKkTiYv4jpsAzSuxcxZEyyTPVcDIcSyIF1WBiLBkZ3CTdRspBPZM/HkyswNp7GzUVf/J7jb/AvJsrs/gSS/Nvqhq83Lt/TOHMqgqkLNPxeODaWbzeeNLWDZEKNOC11ZZOwGdf87oI2iTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnqLUCUl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E6C43390;
	Tue, 27 Feb 2024 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709027698;
	bh=Zk7o7sUzRba0JQK3Ym72GL+cw8hLT3hXk9Ws635mKEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WnqLUCUl8/K487MIrzz6ZMjwOJrCDyZ+ZKed0dZ8lbi9ByvdpCTV4qRNapB3cgQPb
	 R56gPXIPaTd/AY9R//tx+p9WgeSpvC7fTCFYarkQfIHkQ9UW8Jc6vfLCBYfkLIGvdP
	 GtTOOgAYH0UjQeoZtaUSzKLRL/GQt8xRsf32dctZDqMJXsMvV7WMSH8d61pAj8edLJ
	 MfVdj+yHBHb3I2z5f1TDaEUxZYuAzMZfH0/IndhewiZayhZovRCFHms7zU900Q9lVa
	 Zil4mteaMTaJ0vcmxUNczErm6TFXg6vsppK5Q5XVZRcm6lxxa4FFoOAMX1oKW0JJD/
	 rpr6wSNKqVDuQ==
Date: Tue, 27 Feb 2024 09:54:53 +0000
From: Will Deacon <will@kernel.org>
To: Mr-Mr-key <2087905531@qq.com>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] Fix 9pfs open device file security flaw
Message-ID: <20240227095453.GB13551@willie-the-truck>
References: <tencent_3FBF289C57BD1C8C31601110D5726C3E380A@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_3FBF289C57BD1C8C31601110D5726C3E380A@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi,

On Mon, Feb 26, 2024 at 12:31:55AM +0800, Mr-Mr-key wrote:
> Our team found that a public QEMU's 9pfs security issue[1] also exists in
> upstream kvmtool's 9pfs device. A privileged guest user can create and
> access the special device file(e.g., block files) in the shared folder,
> allowing the malicious user to access the host device and acheive
> privileged escalation. And I have sent the reproduction steps to Will.
> [1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-2861
> 
> Root cause && fix suggestions：
> The virtio_p9_open function code on the 9p.c only checks file directory attributes, but does not check special files.
> Special device files can be filtered on the device through the S_IFREG and
> S_IFDIR flag bits. A possible patch is as follows, and I have verified
> that it does make a difference.

Missing Signed-off-by line.

>  ...n-kernel-irqchip-before-creating-PIT.patch | 45 +++++++++++++++++++
>  virtio/9p.c                                   | 15 ++++++-
>  2 files changed, 59 insertions(+), 1 deletion(-)
>  create mode 100644 0001-x86-Enable-in-kernel-irqchip-before-creating-PIT.patch

(aside: I think you've accidentally included another patch here)

> diff --git a/virtio/9p.c b/virtio/9p.c
> index 2fa6f28..902da90 100644
> --- a/virtio/9p.c
> +++ b/virtio/9p.c
> @@ -221,6 +221,15 @@ static bool is_dir(struct p9_fid *fid)
>  	return S_ISDIR(st.st_mode);
>  }
>  
> +static bool is_reg(struct p9_fid *fid)
> +{
> +	struct stat st;
> +
> +	stat(fid->abs_path, &st);
> +
> +	return S_ISREG(st.st_mode);
> +}
> +
>  /* path is always absolute */
>  static bool path_is_illegal(const char *path)
>  {
> @@ -290,7 +299,11 @@ static void virtio_p9_open(struct p9_dev *p9dev,
>  		goto err_out;
>  
>  	stat2qid(&st, &qid);
> -
> +	
> +	if (!is_dir(new_fid) && !is_reg(new_fid)){
> +		goto err_out;
> +	}

We already check is_dir() immediately below, so I think you can rewrite
this as:

  if (is_dir(new_fid)) {
	...
  } else if (is_reg(new_fid)) {
	...
  } else {
	goto err_out;
  }

I was also wondering whether we care about symlinks, but I couldn't get
S_ISLNK to do anything useful in my local testing as I think stat() is
always following them. So that should mean that we're ok.

Will

