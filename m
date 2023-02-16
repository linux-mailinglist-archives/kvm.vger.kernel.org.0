Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B707699BE4
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBPSHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBPSHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:07:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12olkn2048.outbound.protection.outlook.com [40.92.23.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40E4505D1
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:06:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWZ4s90CAovWoy1GV09tJ2/86C9QLiZ5sCC1mnU/vNlDBJNIew5G3sQ51Yphbv14DNKxrSGSt/Ua5OR6V8fSYV55a9OUm/LDyXuIkLD8w+MpM8uStSEbq6WqnPLXqn8j8MZBJLRI1RisAOw4OzVO6m6dzTod/+FxU9nMgGsGzSnZY6PH5EgRYyOMG0dp7VqFc/HIgi52J5Oku1lxmdNIT9ln3vzVGGPNgc1tuhl4XPUHO7TSEF2N6r98VvMaOZ+CBvBIibZQNf6TJuY880PJsVLC0wmrpVeYa1+VmL0G/opqcNbgn4U2vjymZfnJKSOAq4OFJhgE5IHN3aM9c13kKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVXfZ6n+H1H2kk2OrBC9dbgWprlhZ319Yj6PIi5hEm8=;
 b=TQBydniXVIWDz0tuHTjQZ9zgCjjy+I03rnLGR0hvNc0mpn+mOMWhsGVJo53CodhGwj9kkEUpn9tPaIpP9ZNLv1wX5/JzRqt/WwmBpHLModxuf924dhaJKnxBBC65NHntUbgkoZ5JQMAESdY0g7v5YvvA34oGuMwzEh1Fb+PUCTAM3dpJOsBMgTX7J7Rw676pdE0csEIBy7fwiZayOswGxFQA7Tqcw7NnPNaYZIxYfx0YiTWEpppGPFdlpWRh677k/+X0kLLv2e99gouv+NjejCZYRsUB5cW31s9BpjY0KV6EqLFaOHf6ij4T2qq4IYNkFO/sYBo8CpGyryrQKeV2lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVXfZ6n+H1H2kk2OrBC9dbgWprlhZ319Yj6PIi5hEm8=;
 b=H25jeDXxoORHicGP1VgFabSuJkjpx97owzXOLJesy9e6BbebHmKD7uwXo1lXu9wzQAlbo0qKzJfaFRgN0QzEGLCvq6VEW5njqJkTa5d9pjRrnxgE+uZL7UiLGBNAuqV4FmdYk7HFie7YvXPswidIkBbyZiZ8hDuvbsdw9dmMAioZBR9vcfT4CKsD3lrQeck1I1DW2qJbbPhgef9ZRDiYpoGY0jCJ9bGdhKQYXYZXKA/MNvSIN0i9yZL+gt/GgzWlfoWc9F9jsuNmn2ShkkqUo8tqQtBd0W+KnbwVsxgD0GWJBX62rltfPB1eXhQ2pYwhU3TGY3TxZrHI8bQhyHvHIg==
Received: from BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11)
 by MN6PR12MB8589.namprd12.prod.outlook.com (2603:10b6:208:47d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Thu, 16 Feb
 2023 18:06:47 +0000
Received: from BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853]) by BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 18:06:47 +0000
Message-ID: <BYAPR12MB301441A16CE6CFFE17147888A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Date:   Thu, 16 Feb 2023 19:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
Subject: Fwd: Windows 11 guest crashing supposedly in smm after some time of
 use
To:     kvm@vger.kernel.org
References: <c0bf0011-a697-da29-c2d2-8c16e9df21cf@outlook.com>
Content-Language: en-US
In-Reply-To: <c0bf0011-a697-da29-c2d2-8c16e9df21cf@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [3TMemEwSHzBIuaHqIV2imWo+zJsj61k3]
X-ClientProxiedBy: BE1P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::10) To BYAPR12MB3014.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::11)
X-Microsoft-Original-Message-ID: <a561568d-9e76-08ce-2c7f-2626d5ea1e76@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_|MN6PR12MB8589:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e0d24d-db4b-4d24-e049-08db10489143
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6H4n29yRvA4zwEPQVIMP1E4D1OtYVOY1UHAcoq2OczszSJ7JEtFbRK4I1BGd+W2taqCgIlNU8ip/rTYGykCtdIgmb6juaMDKsQw1ZA+wQGa2UYZn/bUFX1BzWOp4WcNBoiXNYqJ1NYiU5nR0UPRYQOEeOxpCz3KVZn81bbwdqTPc7qmkf0IhE895ybaBuiuqMLzBGL7caOVqxOhpDGC2b5ZL/1jPrCqWR5q6cly6HVd2rbyxyNaWJyg089cvkWMnoaZn+3cOQDqz1YjcfGcEBEjsXzdwF2xZhkBVwJymMu9Zyut2x50dQvixJF3ZdYdjGC5v3UVvQwq14x/qsDTPzbz2Siq1SjcdEuhng/UcLvVk+QopgVbOC60YS4mRvpknV/QPRqA4XOUJ/npCL30EIorJwruGfvnZCQcAG8PiMBMXAAOe/yBww8qmHbG+gfbFSMJ5Vyyu10Bsb1tYbLzorvBfKEY4o07po76wTVSKx0ufynQoue1mR2/qH6BLlCfVKTeXYUYcSqJQKbVOWvz+NfcObkxjbJ3BBhdIJEskIhBGdJFp2ZBzetNFO+fcleaVoouOOWu8D8LDyELHX8cmw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QStxRW80WnhlYkFoTDQ0dlgxK0hHa1N3VDd3aG5PNlhBTFVtMjBlZTZUS2la?=
 =?utf-8?B?c1FDRXRkQ09RZC9BdzkrL3J0aklFQlU1T2M3cXloREJZYUd5UnZ3WkE3aGVD?=
 =?utf-8?B?Wk9XTnFrZ0VRdkhJQnJ5eENNa2RXRjNuUmdaTXJkdXlnNXFvb1h0ekhFRE0v?=
 =?utf-8?B?ZmZRMk1IaTg0UjVXRmtPL0ZXVmlKSktUSW9KbkZmdmNuRnorRGJvanNVamFR?=
 =?utf-8?B?cUhRbUVtSnR1ODlzK2p4WjI0Mzg2MTdSNnVCUGg2U1JBaTBMaDlSYTgvUDVj?=
 =?utf-8?B?emo1d1JBczdIY2dmUStTRkdWem94aWRKVEpxbE1hTEFiYjBIcDRyekNPTytZ?=
 =?utf-8?B?bmg0UXJJSURKbWJWa3Z3eENpOHdIT0hXeldPaXdTbWtVRDFDbm05dWZ1M2py?=
 =?utf-8?B?TGZyQ01vYWxKYnZ3N2xPejdvVWI3ZDNDZ1U2OVdWYmlXRVQ0a1BRdE1SWThU?=
 =?utf-8?B?eDdFL3BCSlpGY0tzVEFRVFFOenZLUjhRMnRGd243Wi9VY2dtcm02U0s5aU52?=
 =?utf-8?B?T0o5a0tZTDlYMkU4bCtFTk5yemQ3V1FtWHViSjVjK2FVOXViM0J4Y3ZZYVI3?=
 =?utf-8?B?YUpCTE1CR0VZQTdBSDErVG4rZVhYclRJQ3FUdURiVWVWbVhTWGY3UVlXVVNY?=
 =?utf-8?B?K3NBYkNlUFR1QTMrNW83bzFSeGxwVEdkTlF0MTI2ZzZCS01lV2VIM1Zzc085?=
 =?utf-8?B?Tmd3VUJIZi9iZERBVVZJRlk3SmJRY1hWQTdQd2xwTlF1eVpxSnlLOEhuRzUw?=
 =?utf-8?B?MDRVc3ZodFJ1VUg0T0NHSW5wS3ppUnpVcU81akxyS2w2WnJPOUo3ekJVV0lw?=
 =?utf-8?B?alJiQ0VUTDdIZnZHM1pDMU5hbWg4VWtOUUJ1aWZEemNRbXVWK0xMZmxhYnVH?=
 =?utf-8?B?bERPV1k0UzNQaWhIbnJrdjFrcnY5QWhndUUzM2R4ZnF3ckdVeE5hTEtNSVAx?=
 =?utf-8?B?bHZ0cjlKVTNiK1VKT3pvNUY0UGhDdE9ERXR3YjNGOSs2SHo2QlZUYTlSSHU3?=
 =?utf-8?B?V2dJQ2VhUGVyQS9QUkdDZDVmZ25QN1JILytCZDVJQmYyS011K2ZzSVovOVh6?=
 =?utf-8?B?dkRCR2tkTDFCMkh2UUlHeDJLNThudFkvS3N0Myt0VWtVSTVBeElCai93V05k?=
 =?utf-8?B?blpWcTVScGxaVnVPc2poaURveHQ0cmVLSmw0Y2RraDJ4Vm9kUmFLcDhidHI3?=
 =?utf-8?B?TGlBVjU5THlYenQzVGFOT2JiU3pGS3dIbG9QRnlUTnBXR3JyQVBOUjVDQW5t?=
 =?utf-8?B?NE1oNUYvRjF3aHRHdFJpUGhhTlhkNTRJL2hvUUtFZlRUQ2s3enZiT25ER0h5?=
 =?utf-8?B?KzgzbEE1djBQUjh1V1JTSXZHY0gvZXIrS2svbko1bUp2VEY3RTZuRDEzZVRh?=
 =?utf-8?B?V2NkSDdSRjZraENYeURwMEk0c2ZnYy9pUURGTXJTWGs5QXY3QU9nelFYbTEx?=
 =?utf-8?B?OFN2dXpzaDJ4aGtRZi85WEM2cWJWZ2psSTlYVkJMUGJ6NEFjYXE0TGt3Ui9Q?=
 =?utf-8?B?Vi9CVENxZTdGYVVPOUtEZURyR0k1NnVjQnpoTXRwWC85dVJldDBBcjRlcEpv?=
 =?utf-8?B?cDRYNEc0RzJ0ZmIyQWF5QW9YUmlxWVlLc2cxZ1gxam9jRkZ4UTRIbFJraTFT?=
 =?utf-8?B?M3lQNGhwa3JVMDhzU0hScGZ4QUp0MlZNWlpaSTlKMEhMM0RIMklOZ3BHZVJS?=
 =?utf-8?B?YlZ1eDhTSzEzSTAwK2RTKzhmMXROUEhCQkVVemhYWUUybFdhV0lsQmdBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e0d24d-db4b-4d24-e049-08db10489143
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3014.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 18:06:47.1078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8589
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resending to kvm mailing list, in case someone here might help... Also 
will try again with newer ovmf, but assume it happens.



--- Treść przekazanej wiadomości ---
Temat: 	Windows 11 guest crashing supposedly in smm after some time of use
Data: 	Fri, 10 Feb 2023 15:48:56 +0100
Nadawca: 	Michał Zegan <webczat@outlook.com>
Adresat: 	qemu-devel@nongnu.org



Hello.

I have windows11 installed on a vm. This vm generally works properly, 
but then might crash unexpectedly at any point, this includes situation 
like logging onto the system and leaving it intact for like an hour or 
less. This can be reproduced by waiting long enough but there is no 
single known action causing it.

What could be the problem?


Configuration and error details:

My host is a msi vector gp76 laptop with intel core i7 12700h, 32gb of 
memory, host os is fedora linux 37 with custom compiled linux kernel 
(fedora patches). Current kernel version is 6.1.10 but when I installed 
the vm it was 6.0 or less, don't quite remember exactly, and this bug 
was present. Not sure if bios is up to date, but microcode is, if that 
matters.

Hardware virtualization enabled, nested virtualization enabled in module 
params for kvm_intel.

For vm using libvirt, qemu 7.0.0. Virtual machine is q35, smm enabled, 
processor model set to host, firmware is uefi with secureboot and 
preenrolled keys, tpm is enabled. Most/all hyperv enlightenments are 
enabled.

Using virtio for what I can including virtio-scsi, virtio-input, 
virtio-net, virtio-balloon, etc... installed windows drivers for all of 
these things.

Guest is windows 11 pro 64 bit.

What crashes is qemu itself, not that the guest is bsod'ing.

Below is the link containing libvirt qemu log, containing the full qemu 
command line and also the crash messages. Note virtualization is 
disabled in vm even though nested virtualization enabled on host, and 
hyperv not installed on windows, so it's likely not the cause.

https://gist.github.com/webczat/1f224e7ecdc17c5c26316e0121f4ed43

