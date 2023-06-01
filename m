Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89444718F87
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjFAA3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjFAA3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:29:36 -0400
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6DB180;
        Wed, 31 May 2023 17:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1685579374;
  h=message-id:date:from:subject:to:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Y6SsEnsaM8o7KvcU97XU5A8Uo1QhypYHIPY83uZg+qw=;
  b=hcrGYICAXDalXko3RFqeqx4GbMy6GaN1yuO+LOX5uYKazhjvx4VPscNm
   fW0xuiOT/dGQKjuqwcY19KeUJLUC9Q4V4tRsg/S2L4OxhCL7NFDkn2jGM
   1sA0DV+M9WOCB9Lr/ThrbOP0SOk9wplFK1ysKGx0YoiQ72KNqqb2LsJdT
   M=;
X-IronPort-RemoteIP: 104.47.73.47
X-IronPort-MID: 109906797
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:fMxYXaq2vsh2DEkaVi7slwjgguFeBmLRZRIvgKrLsJaIsI4StFCzt
 garIBmObv6KNjHyLdAlYd+yp0pUu5XXm4VrTwc5rH88RCgV8ZuZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpA1c/Ek/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKq04GtwUmAWP6gR5weDzCBNV/rzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXACgIXg7Shrq0++u+SMte3/wvPJTiMJxK7xmMzRmBZRonabbqZv2WoPN9gnI3jM0IGuvCb
 c0EbzYpdA7HfxBEJlYQDtQ5gfusgX78NTZfrTp5p4JuuzSVkFM3j+OrbIW9lt+iHK25mm6xo
 G7c8nu/KRYdLNGFkhKO8262h/+JliT+MG4XPOTgp68y3gLCmQT/DjUnaWPriuC+1XfmGNxSa
 FcLwxgVtrQboRnDot7VGkfQTGS/lhwbXfJWDvEz7gCdjKHT5m6xHWUNSDxKQNMhs8AySHoh0
 Vrht8vjAjp9sbuUYWiQ+redsXW5Pi19BXMNYT8sSQoD/sX5p4cynlTDQ75LFa+zgdrdAzz8w
 zmW6iM5gt07h9Yj3qG68FaXxT6hzrDFRxA4oAXeWHmo6Ct9ZYi4d8qp70TW6bBLK4PxZknR4
 lAHltKY4eRICouC/ASNWOwlDqC14OzDOzrZ6XZ3EoUs7SaF+nitZ4lc7ThyYkBzPa4seyfuY
 UrZvg5555JJOnauK6htbOqZE801xK6mFsngX+qSYcdWfpFZcA6B4TEoZEiM0mSrm08p+YkzM
 JGafMLqFnAXBahgyhKyRuEAwfkqwDwzwSXYQpWT5xe51JKAa3OPD7QIKl2DaqY+9qzsiAHU9
 ctPcsiH0RNSVMXgbSTNt40eN1YHKT48H5+eg8VTZ/WYK0xjGWUrFuXX6bInZ4Fh2a9Sk4/1E
 mqVX0ZZzB/zgCPBIADSNnR7MuuzAtB4sG4xOjEqMRCwwX8/bI2z7aAZMZwqYb0g8+8lxvlxJ
 xUYR/i97j10Ymyv01wggVPV9eSOqDzDadqyAheY
IronPort-HdrOrdr: A9a23:roIDNa5AoZVy2DTJNwPXwaiCI+orL9Y04lQ7vn2ZFiY5TiXIra
 qTdaogviMc6Ax/ZJhSo6HmBEDmewKnyXcV2/hrAV7GZmXbUQSTXeJfBOfZsljd8mjFh5ZgPM
 RbAtdD4b/LbWSS5PySiGfYLz9j+qj/zEnBv5aj854Hd3APV0gP1XYeNu/WKDwVeOEQbqBJaa
 Z0q/A30QaISDAyVICWF3MFV+/Mq5nik4/nWwcPA1oK+RSDljSh7Z/9Cly90g0FWz1C7L8++S
 yd+jaJrJmLgrWe8FvxxmXT55NZlJ/IzcZCPtWFjow4OyjhkQGhYaVmQvmnsCouqO+ixV42mJ
 3nogsmPe5093TNF1vF6ifF6k3F6nID+nXiwViXjT/KptH4fiszD45kiZhCehXUxkI8tJUkuZ
 g7l16xht5yN1ftjS7979/HW1VDkVe1m2Mrlao2g2ZEWYUTRbdNpcg0/V9TEr0HACXmgbpXWd
 VGPYX53rJ7YFmaZ3fWsi1Gx8GtZG06GlO8Tk0LqqWuok1rtUE863Fd6N0Un38G+p54YYJD/f
 74PqNhk6wLZtMKbIpmbd1xD/efOyjoe1bhIWiSKVPoGOUsIHTWsaP6570z+aWDZIEI9p0vg5
 7MOWko+lLaQ3ieSfFm4ac7sSwkGA6GLHbQI4BlltREU4THNfvW2XbpciFqryOiy89vcPEzFc
 zDfK6+OMWTXVcGKbw5oTEWZKMiWEX2cPdlzurTCGj+1f7jG8nNitHxVsr1Cf7ELQsEM1mPcU
 frGgKDafl90g==
X-Talos-CUID: 9a23:xGdwt2OWGNtNTO5DQCxX6h8VQsIeK3jf7kWJG0OoVG9lV+jA
X-Talos-MUID: 9a23:rriRqwuvgnHsPVvBjM2ntQ1aZOxx5PuXUAMDnNYdpPC2DjdsEmLI
X-IronPort-AV: E=Sophos;i="6.00,207,1681185600"; 
   d="scan'208";a="109906797"
Received: from mail-dm6nam04lp2047.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.47])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2023 20:29:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm1AYYUwemuU1L956zTfSn6h7n9Y+zyEX6j7FiNzjBcWkC9Q06t47TFXvoUsXeMsS22+69owdJLxOcgf0HdtxOrh85lEj3g1pxLSPdTsg/esHSB2uueaq3bpSdvTPCCnyG/uuwLacWNmj+hiallmW/013NFqyVlyeT62QYtwxYfI5QtXiK+yUxaZXCJ8//HW3QoCsX1qOMYLRy8v+yXzhqxg5eokUBkgwR3JgP1YyYqqdM1j4Bb99ULMCrq7pekQi+9x2yxihVByy0uL8g98n3qIRUsQ0kFhQud43h6z/YiyH+a3154TU9Lw1ryw27jdIbmDUotCBQWWje8EU15mIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6SsEnsaM8o7KvcU97XU5A8Uo1QhypYHIPY83uZg+qw=;
 b=Y0B7eetS6Ejpqhv1GrxLxf1z+nu3x55xlaCwl3ofRnmj7duDe7e+NX5SBRk6mRMcUQW3KFEMfQzuGIX8guCz4Y2d7dSlwSVA3EtKZw5FhnjcM0uauutt26nigRj4kdg2mLbOW1ThgDRsFRFgheoQbd9scHNfFVT2hphziMhmitsa62HNCIzcHvfWtlWmzHhOWRgC7UcZ9Imm34mUsn4j68XXNuOulUhC0dW55MkXjldTBqt7Yv+n3k8KmWpWM74CdY3iNj91w/oINocBqXVNoBs/NLai3e+RNpS53zMbvwS8IuFXeIMYiOLTr8kN9kLgcDWyHuJukz5YMLqb9ipVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6SsEnsaM8o7KvcU97XU5A8Uo1QhypYHIPY83uZg+qw=;
 b=fYlGtOHuKOJJFsy2Zh1H/CCYarvKtq5Me+bU68PiUuEIjbpZIC9TwFxgG/8JX5/pdX2WQD07gcGRS3cKZie2N8NCu/uuK4QH4/CcAyGmbukL0R+/RHBSmBKaPm5uYaq0H/2i6OcNVjd3lBUVJLe6ZicJqrOQZqBLeqZQZajeEKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by BY5PR03MB5233.namprd03.prod.outlook.com (2603:10b6:a03:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 00:29:29 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::10bb:98bc:e36d:36ab]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::10bb:98bc:e36d:36ab%3]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 00:29:29 +0000
Message-ID: <3b48fae8-1bae-c30a-e6ef-25901314ee39@citrix.com>
Date:   Thu, 1 Jun 2023 01:29:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Content-Language: en-GB
To:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Milburn, Alyssa" <alyssa.milburn@intel.com>
References: <20230531150112.76156-1-jon@nutanix.com>
In-Reply-To: <20230531150112.76156-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::12) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|BY5PR03MB5233:EE_
X-MS-Office365-Filtering-Correlation-Id: d2dcab32-27b6-4fef-67b2-08db6237430d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrAxscAgWFcWh6pIeXdH4U4hBDih6h+wFQew/JJDDXnNhb0iDb8s32JlUDm5tKOYpmSY1j7KXoOIunsuHuyaViaxlR3UrZmge2BzC9jD65cSLscURRd+YHsoIRz6KYIZmXNPFvVpqNJ1vQTT0PCMUtKXSXMx8LdqNBR1bt2/QuLVFTz9o6nq4l40NRqju/ywlqwpWex7YSLUqj2KDYekWMNi7LgzoinrrW9N7AGFG3u5jWduCEJVLiVGlCEGSCQLAUlCgK2hczTzrwZ0l2HrNMxbjsFk9hT2zTo6pVGtLSxtQU3rhrqOnB88/QtfXCE2+2OYnfNz2IwUXp9vSesiJDATRyf7/+qM2MykOw9S88yKR2cvZAnJ9Ken4SxWc6el/Cdw8O35++TKP/cmWU6/oePN2VpkHHpu5izYBGqbdprk0IPfSD6lEMGInAr41C5woplwpwkK43eHiLA4z+zvfVSOPrwUzj7C35vfGuQ9R1CNboZQGzU7OHEb0cJlGnnx2uPrn3P9eCAe2rCRSOiWDIuTG76+GElpw63jHVFTZCrmfTbC+N8ck/FPl5saIIh8JJbrk+p4l1iL7xLwTfEeIJc54T7l8Kv4YuV2jzDSTK5g96Ossc621EvO/DcxwPxU43GAwNqZMKt3mpj/3CrNma6Sb14fIidBg/lmZao9bX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(966005)(38100700002)(83380400001)(41300700001)(6666004)(31686004)(53546011)(6506007)(6512007)(26005)(6486002)(186003)(2616005)(8676002)(478600001)(110136005)(66476007)(66946007)(921005)(66556008)(82960400001)(296002)(316002)(5660300002)(7416002)(8936002)(86362001)(2906002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFJpUXpTYXZ1ck81ZXJBSmtjYVhUcXc5YUdQVFNHNVpVKzRPVTNQTHJRbnU4?=
 =?utf-8?B?c3JwWTB2MTd5SUxUL1kyVkIvVWl6cys4MGQxbGttWWJoeUpQVVI2bEdjN2Na?=
 =?utf-8?B?dWdUaTdKZld0SEtBNE5MQ0Y1YnROUWtIbi9BWnRNTTBMdWQ5V1lpSkZTRnRi?=
 =?utf-8?B?by9NcHBYaGE2cG5zRGVGc3Y3RDJnTUJUQ0pHOGZtQVBtQzlRVHBpcWFqa3Uw?=
 =?utf-8?B?dURuRjdaUGhiNTZsVEZqaGxmYzZqTllzc3B0M05DcG9nc2Jnb2drSUk4Tklv?=
 =?utf-8?B?SmhsT1l1ZHFkNDVJRyt5aHdVbjFVRzl1bWJPSENpazVsNjRQWS9DYkRpK0sr?=
 =?utf-8?B?RXBhc1dDWnRjc1ROamRJVHo1cm5pK3JDcm1uMU1yWFVIUHpIM0U0QUR1QzJw?=
 =?utf-8?B?c28rRXA4czNhdUxrdWNMdWp4TitaNHVBTUdXOEVyN0QzWG1JZGM0L3lkcnc3?=
 =?utf-8?B?T3pVc2QvWmNsS25obk1HYmhrOTNOZldMUXhBa0F0NEFQN1p5SFNCNjV4ME56?=
 =?utf-8?B?cUFiNXFhV1V3WjBwS1dmOVpyRGFHU1pRL29HUjZCaTJFZHJzOGxwK2xpT28w?=
 =?utf-8?B?SDFhbGhqdEp1bUNmZ291Qm02MWFuUTRheHkvVWFxU2VHSytVTnF5alpTS3RL?=
 =?utf-8?B?SnhlZnhZZFljQWY2b0JGaG5zNTIrYmpmQmdTQnVuMFZ0V0tSdXVldWhJOEhh?=
 =?utf-8?B?REpVeHUwUUxjMEZFSUNGWEMrUlByZ3pMTlpGRFdKNGJVbm1ETFd4amI3ZXZ6?=
 =?utf-8?B?OVJqeWN4K09XajdqNUdPeW85VmprcmFFRHRKbkd0UUxkRUEvUGtqcmZEU1or?=
 =?utf-8?B?K2hvS3V6bFVSelRrM2tKY1VtYUpxaVpVK2duYlk4UXJ4b29Kd1dBci9sc0xW?=
 =?utf-8?B?TzlhYzdnbks1dU15T1N2U3NLcU5STEdiK2FwNmpIOE9lMXVWbUFndzhWVE5J?=
 =?utf-8?B?bFdsZUhYM0ZEcEx1akFEN1ZKRVBrVjFHQ3d6US9BYjJSbkdiK0NKaGZ2MXZ0?=
 =?utf-8?B?STQrUWRkU0xNK2FiakRvY0JGc2M0T1JxRHFqOE1wRHNQZ2JkcFFwb2tZS3pW?=
 =?utf-8?B?ZDI2MWlaRlBXb2pzS2tUbGlSc0N3b3VURVkxZXhObWVYQlNDVjltcWcyVWdh?=
 =?utf-8?B?M0pLdW9ZSnFocXBjY1NCSzNvZ1cwMUZPRDU3c0FoTjBpOFpsRFcrMWNMMllM?=
 =?utf-8?B?R3FNNUQyOGdzeHJRRCs4WW5QLytBV1pOZjZaNEFRSEZOQjIrcmNqMEpkdVEy?=
 =?utf-8?B?OHMvQnRjQ05LZytQQm9yVTA0TVB4OFJ5RlN2ODVtV0wweEhuMmFwRU95Vjdu?=
 =?utf-8?B?UWFxZmZkNmp0RFZHVGtSL1oxZ1FwdXJ6Q3BwM2xzYTBYZW8xZ3R6a3hFZ1Fa?=
 =?utf-8?B?ZGZZM0ltaS9TQWQvdmNYVkxvUklldDNUQjBSVUR0MWZJTXMrRVVXZzVOblho?=
 =?utf-8?B?WHJXNzVMeVE4QTBNcWY3aTRLbnJBMWgwWW9hUmREVk9OQzFSOUE4MDkvb0pB?=
 =?utf-8?B?Y2N5U2tBMXlZa3dBUWgyVHZNWGE3Yzg5NHV6aW9tTGgvMTdJZCswT2c4QmpK?=
 =?utf-8?B?YzhoYkY2aUh6aDU2NW1VKzA0bmkydndzT0FNVXVGZWRSTHY1cERHZlZpTFhE?=
 =?utf-8?B?azJUTTNrZUFyNVhZd0lWU2ZSUnNnczBKR21KNCtmakdyVGdjMmRUZjRkTkJ1?=
 =?utf-8?B?VkJhajFNNGFVMGcxczVpT3E0TCtaNGIyT05Zd3diZ25wZ3cwVXpydVRmazNu?=
 =?utf-8?B?ZjNwYUdRU2d4VU8yeUl3L1YreHFZcXFUSTlxZUl0dnY5RitFVXBTYVVGeGcy?=
 =?utf-8?B?NnJ2OWFNSVN3NnozK1dnUVR2dDBENmtEb0ZpeE1PN2d1YXo4NUt3TTZ1M1JM?=
 =?utf-8?B?cFVnTzB3K1R1bEdZV3NVNWM2T1VONzQrYXJ0YzB2KzlCamxsV1dtUWRjeWFj?=
 =?utf-8?B?dlQvMGMzaTNWN1hQNkJFUXkxQ3FQWnovNHgzZGlBVHVIWlFYTDJHUmdGNm16?=
 =?utf-8?B?SmxzcEFZRWFBWUlnOHhoMUtQbGk0aVRGajRocURyUnVyV2ZXdjhweXV5VFBv?=
 =?utf-8?B?cGRha01xakZva2FJNmNLSjRWblhyY2xzVU5OOUxpOXlhUEVwbnZ2UW9MQWpZ?=
 =?utf-8?B?Z0hmb3dtY0t4TUFpczhYUC9yd3h6UU1reWpDdmRyYitCWlBKKzh4cmwrUDBV?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?azBFWjkxNmdnMThRQitNaWVNcFQ4SGZzaXBpcFAxVSt3Z2tpS1c4cVlJR0NP?=
 =?utf-8?B?YmhlQWZWNUYrZWE4VVk5aE55NU1seTlsRzM4TDRzOWRJcVd6WkxXdW53WDNP?=
 =?utf-8?B?eTBYU1Z4dWY3eFVQWWFSRE00S1IyekVVdVlRK2NpdU5naG9RaHRXUFROc2Zy?=
 =?utf-8?B?My9ka1AydnVSc0VnRTl0N094dEJkeXRXK1RTelQ4NHVNUW1MVks4SDY1UmZZ?=
 =?utf-8?B?UlZ4YWNMYXE1OEpoZTFobCtOclczaFZqMWxES3ByNDVvcE1NbW1qS0Z6V3hu?=
 =?utf-8?B?blFvWjdnSUNCR3orQStHM2orV1hyaXVacG9WTU5yN21mRlpUYUVDNTJBYVM4?=
 =?utf-8?B?YjBnY2dTOXU2ZlJ5MDdtZ1h2c1IzYkFPdnFucXVVL2FGMzN5dm84MlA3WVJS?=
 =?utf-8?B?Q1QrZEw1VlE0RS9tSkEzdE45eXUzMVJyM2ZCaWdoUjR5N3BvRlhhbXFkWURL?=
 =?utf-8?B?UGFjaXh2YjlBZVZTbjhWRGo1ZXQ4ODJZSVl5SUpDWW5MaDE5UXVKalEvVlhU?=
 =?utf-8?B?ZWpnWnltZDhsYTJLTitWd0QyNGZiVnp5VnF3L281SnFBdFRXS3FtcUZuZG5z?=
 =?utf-8?B?c2dmelc3eFZKUjl1VTNDdTRId0RVYWNoZVVpeFRva1hkNWwyaTFoSmFzNEgz?=
 =?utf-8?B?Wm9KVVJJMVVUQWxhVUovcFZTdkxFUFNmL09YcVN0ZjYxc01QcWk3WE5JQ2ha?=
 =?utf-8?B?NkhrcXpOMHVnazVQTmtEQ0Q0a0E0Ym5VVXB6VnZSSVdtRHNoSHNqdmNlSzcx?=
 =?utf-8?B?ZWQ0SHB3eWR1Z2tQK0hxQVhPS3FiN3dZNWlzdHBPUnNoRU81UWNtcVp4OEls?=
 =?utf-8?B?TjlEMlc4VTc2UjVNanhRbjYwa25xekFWYVB5MkNyOVlwa3pHTkNPMVN3UzhI?=
 =?utf-8?B?WlFKUVRMZngzdURrdVJ1bWw1dmJjaG9KR1lxRys3TVpCNmVRVlpnTUdHWnVN?=
 =?utf-8?B?VzVZNjhoZkFEZGVuRUp6MmJrVlRLUngyOVVjdEFoMUp5RmlmMG1CbXMveStu?=
 =?utf-8?B?TlE4N1BkNFZuR29XNFNHMzNYYmxFY002Y1pZWWZtLzlBeVEzRThGai80NGV2?=
 =?utf-8?B?clVxRHNMTzhNZTcrTFpOZ09FdkQ0blIyZVdibElheG9KeTFPTkdtYkkvYVZ6?=
 =?utf-8?B?UmpxRWhnOUgrSllkM2M5UkVqMk5NTDBLRXNQWGNMdTV0YUFmV3MzdktTQ28x?=
 =?utf-8?B?Ri9KbmY3YUtKdWwyeXNnNG00eC85aTQrUFNOdGs4VzVSNVh4TitzN3IwZmdh?=
 =?utf-8?B?ei9adTYvczlzT1M1U2tUSkpiMHVDbDFHSitxUEhwNFYzcnl5THkrcXE4WFNQ?=
 =?utf-8?B?QVJtU2NkTld0bGhibXNucExaWlBUSEhwUk4zYmpjR3RmMmJYYllHQXZzbUpv?=
 =?utf-8?B?VXVYa3pwa00yQ2pWOVRvN2JDbnpCUC9XNG9TUXpmRWJCT29UdEVjNDBubjVL?=
 =?utf-8?B?Nk9aNVROU3JHNWVMMjN2eDhXZDdTQXFpWFVkU2R3PT0=?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dcab32-27b6-4fef-67b2-08db6237430d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:29:29.3496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQINbOp3RMl5t2MWQqlbsDUbJTOrBL0Jk1koOZ8ng4794w7pw2b4kaAcg9DyusrPuNQB1LbFu7mosC1bUHp0nNfE0EvkyDIYqeC6g70thFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5233
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/05/2023 4:01 pm, Jon Kohler wrote:
> Remove barrier_nospec(), which translates to LFENCE, in
> vmx_spec_ctrl_restore_host() as RSB-barriers (as defined by [1])
> already exist prior to this point.
>
> This LFENCE was added on commit fc02735b14ff ("KVM: VMX: Prevent guest
> RSB poisoning attacks with eIBRS") in the 5.19 timeframe; however,
> commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections") in
> 6.0 timeframe added a LFENCE for X86_FEATURE_RSB_VMEXIT_LITE was added
> directly in vmx_vmexit, prior to CALL vmx_spec_ctrl_restore_host.
>
> For posterity, vmx_spec_ctrl_restore_host also will execute WRMSR to
> IA32_SPEC_CTRL for X86_FEATURE_KERNEL_IBRS or when guest/host MSR value
> does not match, which serves as an additional RSB-barrier.
>
> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html

Yeah, unfortunately PBRSB is insidious.

From memory (please correct me if I'm wrong), the required safety
property is this:  After a VMExit (if IBRS was set prior to exit) or the
write to MSR_SPEC_CTRL setting IBRS (if IBRS was not set prior to exit),
one single CALL instruction must architecturally retire before any RET
instructions execute (speculatively).

There are several ways to arrange this, but they all basically boil down
to having some serialising instruction between the first CALL and first
RET on any reachable path from VMExit.

~Andrew
