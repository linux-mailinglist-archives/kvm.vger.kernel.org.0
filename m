Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59875188336
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 13:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCQMKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 08:10:36 -0400
Received: from foss.arm.com ([217.140.110.172]:36322 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgCQMKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 08:10:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 227D030E;
        Tue, 17 Mar 2020 05:10:36 -0700 (PDT)
Received: from [192.168.0.106] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2BB03F534;
        Tue, 17 Mar 2020 05:10:35 -0700 (PDT)
Subject: Re: [PULL kvm-unit-tests 00/10] arm/arm64: Various fixes
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200206162434.14624-1-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f14ba398-b838-151d-0c27-1cb9992fb27a@arm.com>
Date:   Tue, 17 Mar 2020 12:10:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/6/20 4:24 PM, Andrew Jones wrote:
> Hi Paolo,
>
> This pull request contains one general Makefile fix, but the rest
> are a nice collection of fixes for arm/arm64 from Alexandru.

Gentle ping about this pull request, in case it has slipped through the cracks.

Thanks,
Alex

