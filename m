Return-Path: <kvm+bounces-53602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E02B14787
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02DED3B99B7
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 05:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B91221D92;
	Tue, 29 Jul 2025 05:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRPrBDnQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3DD38B
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 05:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753766377; cv=none; b=FPzuqYNPtylhPOfV6TMzZ6fjJFEYxeJ+FHYDwgyrVp+BOHtdWg5RuajfW+iAVorchJSD9v1nPE5RLrwZuuxw92XF8JvSEOPas83Kda3hJ2RAgx0KsBvJSCtp/SO7UO+Astjwe/KNz9xmwKvMW4polUCvNIJeaFKUFBLj5X4aaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753766377; c=relaxed/simple;
	bh=+y/sKSaVc5FXiOM424thqlCCVx+tmj7Lx+/lmwFcOow=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=S/Z98ru86UXo4HRn4ojeoV1MG0RnYCVv54MUMiY0udLSpC7gMvM0d+TfUaPqmwGZmjHI3xO5nfxVIYtM8qmw4gmRLWTiYK9VPxm3lQh4x5w7aWdSTYCg0F1L9oGmdaTIIN7/3qQIfV7LanQm9PfyO0dWjREs4KG26VoB212V6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRPrBDnQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C474BC4CEEF;
	Tue, 29 Jul 2025 05:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753766376;
	bh=+y/sKSaVc5FXiOM424thqlCCVx+tmj7Lx+/lmwFcOow=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uRPrBDnQb6up2pcO4XKADlDZRY9We04YvCwGEiHMhuru0j7iznO65H5kuFOmGxnB1
	 KVXk0kmiqTIlOZEx9CihKh79K2YqdtgCp8uAX37VHL4hP3x6+wZiea8yy3/iV9863z
	 x5ygJVMwT+BGIbzDEG+4+LxQwSxkeZ6uZJrywz90vuKM9FeHmptNdIGII6RChUvOhO
	 dPiOqVtwd0d1d9EsioWgM8u75RfKzYW+vJejeaupuYQWuWvP552w09Ltbq0cby6qgP
	 YMXqsaMolyaqynhgJDsnncvpIWBQiiOCdQleowBiU8EogCM4KHn+TIAMT9a6Yu5Y4s
	 T73XIIIVRYo8A==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
In-Reply-To: <aIZxadj3-uxSwaUu@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com>
Date: Tue, 29 Jul 2025 10:49:31 +0530
Message-ID: <yq5a8qk7bml8.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> This also allocates a stage1 bypass and stage2 translate table.
>
> So this makes IOMMUFD only working with SMMUv3?
>
> I don=E2=80=99t understand what is the point of this configuration? It se=
ems to add
> extra complexity and extra hw constraints and no extra value.
>
> Not related to this patch, do you have plans to add some of the other iom=
mufd
> features, I think things such as page faults might be useful?
>

The primary goal of adding viommu/vdevice support is to enable kvmtool
to serve as the VMM for ARM CCA secure device development. This requires
a viommu implementation so that a KVM file descriptor can be associated
with the corresponding viommu.

The full set of related patches is available here:
https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-post=
-v1

-aneesh

