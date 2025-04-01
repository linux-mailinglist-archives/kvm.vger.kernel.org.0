Return-Path: <kvm+bounces-42291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4600A7751F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 09:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDE73A5241
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CB71E835B;
	Tue,  1 Apr 2025 07:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gQt0Ye+/"
X-Original-To: kvm@vger.kernel.org
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA81C3BEE
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 07:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743492001; cv=none; b=gdbp1Cs3t5oHcBf4OKF5uLR6SGV2IH6/34vggp9mCcpgo7P350eiAAsHco6RI19tCZ1lYQThpbkWScxiLBcV9q8swVWfV0kXcnpnvVlMgx3iERLjdU9JuC1O9gB/Dtkpa3EeX+5OempJYia73cbjWCMqU1mp/7V11NPc7ESW4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743492001; c=relaxed/simple;
	bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=DHkmqZ4xH4Mz+HapxHaMc7ZavgO3vBQ7pp64F2ISjM+qQmZ6bYmJG/nGCrtMhBAToo172J6lL8B00SzPNHfdzBLHuGd8aYYh0MppKCodr2KLuGukquUfMf0aDqwYfU/zUEYegGuDGeE7HWwbeLRf6oJcScpNrjTnjDDoi98VPGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gQt0Ye+/; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743491989; h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
	bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
	b=gQt0Ye+/EoAN3yX6eQ26C1ir6a1CwLl7zX3mz20HKteE6LUtH+BAgFMDYjzsljjLhTpr7bWjst34Ada7gnfMz7k64/9Xz7AeFVQqW9jsrzG/5KA6fmT8528u21v9YXWlzbwAxYLefNBP7sD8tR+qthF5I+jW2lE8nWFe3PeuF1A=
Received: from 30.221.98.7(mailfrom:geyifei@linux.alibaba.com fp:SMTPD_---0WTwZcLZ_1743491988 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Apr 2025 15:19:49 +0800
Message-ID: <5e2893f1-41cf-4d1e-9a04-26d984ff46dd@linux.alibaba.com>
Date: Tue, 1 Apr 2025 15:19:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvm@vger.kernel.org
From: geyifei <geyifei@linux.alibaba.com>
Subject: subscribe kvm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

subscribe kvm


