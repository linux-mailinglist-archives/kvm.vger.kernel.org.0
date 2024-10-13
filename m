Return-Path: <kvm+bounces-28696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C88B899B7E6
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 03:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 732521F23881
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 01:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41D34A18;
	Sun, 13 Oct 2024 01:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=purpod.org header.i=informes7@purpod.org header.b="bGDsNtAG"
X-Original-To: kvm@vger.kernel.org
Received: from vps11.purpod.org (vps11.purpod.org [81.7.4.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BBA7483
	for <kvm@vger.kernel.org>; Sun, 13 Oct 2024 01:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.7.4.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728782292; cv=none; b=Pd2brjHxr5o9GikKQiMOxlqXhwxj5Ii8DeQ+wM/XgMemeug40dbi31gWgeYuOwMA1SMBed2WloQg9/k13xC8Vf1o0+FhhQWcDQcVgQT4dNPgkXbX9mk1H4eLUfUiXdIW9X4QwbuVz3sRAJ0BBxTMFRcljVdrStIkJrSdmzlEykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728782292; c=relaxed/simple;
	bh=LBwaLr+wlbr8N/ILBVAzTSG0uUZeAj3452+lutsr+lA=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=TkdqNi9ae47jk12otd0p30Pc+qJJxDGm/n1ndkr3q3N/Dz/Wp0QeW66yJs8RRuGBqukY2sas8/YBoTKC+iB8VN3KcLWPNdqDm2hV3lVZJaX0ZnW3w+XjAxQLTo5i6oew7fiIJIKZjXIMfpQfliUO81MoUD0q8o9o/Hp7Xehk7AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=purpod.org; spf=pass smtp.mailfrom=purpod.org; dkim=pass (1024-bit key) header.d=purpod.org header.i=informes7@purpod.org header.b=bGDsNtAG; arc=none smtp.client-ip=81.7.4.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=purpod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purpod.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=purpod.org;
 h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type:
 Content-Transfer-Encoding; i=informes7@purpod.org;
 bh=LBwaLr+wlbr8N/ILBVAzTSG0uUZeAj3452+lutsr+lA=;
 b=bGDsNtAGtjJwcZr3zWlrefgifcsW+7/UXkPcjnQQW9zFnrA8C2CK3ispHJGQadQDKH/yed1cQEb5
   sw3rHpRfoqKbx7fmFHvFutYkcWvR+RTexO8z/QN5hQeBEY9b/r8dA+QL1h2BZqktA8surGQdi25K
   0KaNwZz3NC7XdCvp87k=
Message-ID: <8733bf14e012545f7603b5e115cd6767787d2ab1@purpod.org>
From: Sarita <informes7@purpod.org>
To: kvm@vger.kernel.org
Subject: hola
Date: Sat, 12 Oct 2024 20:18:04 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1";
Content-Transfer-Encoding: quoted-printable

Saludos a todos

