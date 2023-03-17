Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DDE6BE5FF
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCQJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCQJ4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:56:00 -0400
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBECDDF2D;
        Fri, 17 Mar 2023 02:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1679046959;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=etgz2hJ9InqAM+6m+wfUgjzB6cO6uZJTIErJtNji9Mo=;
  b=XutPesaX98dmvbgJpW07Utt0laQ2xK9VQSe5rkQo0+RA9/KcsfGC1W4d
   BJj8FPfYQD8CLXVUNx8unuBk31U598iPnIC+F316PsPDQjC8f394J+TY/
   H8GsVxTDzxIhH2ZM//M+1nS/2NgTNdzh7kRr5PVvNxNGqXYO3vgO7wSYI
   o=;
X-IronPort-RemoteIP: 104.47.51.49
X-IronPort-MID: 103664702
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:q5mbM67ORl3PhOJH+4mGBAxRtDPHchMFZxGqfqrLsTDasY5as4F+v
 mceCzyHa6zcNDTxfdkjaIXjpkgF6JPdz9c2HlNppHs2Hi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9VU+7JwehBtC5gZlPasS4weH/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5my
 f4CBBcdXDO5gPuS3+mLUeV+u8V8I5y+VG8fkikIITDxK98DGcqGaYOToNhS0XE3m9xEGuvYa
 4wBcz1zYR/cYhpJfFAKFJY5m+TujX76G9FagAvN+exrvC6OlUotgdABM/KMEjCObexTklyVu
 STt+GPhDwtBHNee1SCE4jSngeqncSbTAdpJSuPkqaYw6LGV7m83FxgYXmqDmvyGp3WUWdlcM
 kcp2gN7+MDe82TuFLERRSaQon+NuBEHW9NWF+Q7wA6Iw6vQpQ2eAwAsXj9HM5oitec3QyAn0
 hmCmNaBLThutqCFDHGQ7LGZqRusNiUPa2wPfykJSU0C+daLiJFj0DrMQ8xlHarzicf6cRnz3
 TWisicznfMQgNQN2qH9+krI6xqwqZzZZgo04BjLRGWj7xM/aIPNT4mp71fcxexNIIaQUh+Ku
 31ss8KGxOkKDJyLxGqBTY0lELi36rCFOTvHjFhHG5gn6iTr+ni/cIQW6zZ7TG9pKs8say71Z
 1WVsgRUjLdLMWend71fYoS/Ec0mwKHsU9P/WZj8dddHZJp6XACA+y5qaAib2GWFuFAmlqctO
 JGaWdyhAXYTFeJsyz/eb/0Uz75t2GYlxWrVRpnh5xWhzbeaInWSTN843ECma+k46OaOplzT+
 tMHbc+SkU0DAav5fzXd9pMVIRYSN38nCJvqqstRMOmePg5hH2JnAPjUqV88R7FYc21uvr+g1
 hmAtoVwkjITWVWvxd22V01e
IronPort-HdrOrdr: A9a23:9/zsQ6jCuECkAoYyval6CrJwE3BQXuAji2hC6mlwRA09TyVXrb
 HLoB17726TtN91YhodcL+7VJVoLUmyyXcX2+ks1NWZMjUO0VHAROsO0WKI+Vzd8kPFh4tg/J
 YlX69iCMDhSXhW5PyKhzVQyuxQo+VvJprY59vj8w==
X-IronPort-AV: E=Sophos;i="5.98,268,1673931600"; 
   d="scan'208";a="103664702"
Received: from mail-bn1nam02lp2049.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.49])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2023 05:55:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JR7ts4exPPHbe5ye8DDTiJVGtszddgNaehRztlF0+gjRTfEP0P9QHfDcGbl4g8E3YPqIhHbUTKEd573U49d6bQjlfmq+pk9ZGu0ImQixT38D3pJ1P3vpim6fveuS2qj6WtqEAhGwz4Qn6ZB5G0veVZvr4XEjhwKpViUHHzFoeDuce2Fn1fx2XvsdiDgCc3EM/cvWA0r4spV+aJoPLbou3f4w63tJvXRulDCu9coMNJ20BHaHJthO+/r2Yg268Dm9Ke1RXLlEBAYTHjBc7P9Sx9ea1xtCgJDIbmyw1ELzoTHprPVmJQXqU3zWrn+C2TmrQGWfNEFk3g7Sn0hu2ENjEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogcz5cRt58kVyOc4lRKBPLUVzJ+jNc4UMvprlyOWe4Y=;
 b=Tdaeigljm7Msdo+ZculaBH4VfpSvJswL7zrC05uQiykGpVX+Z5stBV9ewbwNDvME/y2AH8hrysgyDdtPwwtD/Ooi3D+BFa9LGPj6AQp4ABLTltXD0IHI4b5IWkckE9oBs8Gvc1Sm4plvHaG5yqtM09fYwsrfXCVhOHXYlru/dfaQpSYnGYeJsc/n2hmyS4ORvtiOJmFKsznI8FVOyanjs5MMfyzmTFrefbISfmR0cpne4GUReUcfgOYCAXcDcu2fLq7MfPbEI0sgmxRhkIdieMHkjwyqE05jZqUfDrq/RzoME+dWC/SQXZhfnMKh9jXi9zFg29hQ9g0DvVdStr06tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogcz5cRt58kVyOc4lRKBPLUVzJ+jNc4UMvprlyOWe4Y=;
 b=vtii+oeXHn81XKRfIPOBe5uxJCf2VRiMvG0I6hWZ+iHKSiG/V72h8Ef1LE3oJ/vagexUNPamAN+8X6jXCKgq/baUl9jR9JCUJvpSJz3LNiXL0EnlRPE6UPL7tF47B95q23o4FhLB12JE+VhpFprkRsFZwEz2yBB0T/yIhNs6WLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SA3PR03MB7210.namprd03.prod.outlook.com (2603:10b6:806:2fa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 09:55:52 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 09:55:52 +0000
Message-ID: <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com>
Date:   Fri, 17 Mar 2023 09:55:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   andrew.cooper3@citrix.com
Subject: Re: [PATCH v5 28/34] x86/fred: fixup fault on ERETU by jumping to
 fred_entrypoint_user
Content-Language: en-GB
To:     Lai Jiangshan <jiangshanlai@gmail.com>, Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-29-xin3.li@intel.com>
 <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com>
In-Reply-To: <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0205.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::12) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|SA3PR03MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: fad7c4b4-e7ce-42d2-78cd-08db26cdcacd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgH8hrPcU2BhpwWo55AfJ2NzRL6Zl7eAjhnUyViD8ziKLJ9mHil97pGvEyDB1YJ3dWnXjkmsvfxwNU2t6K36N1Z3aFJwcPFZ9AGw0FG2VUIzUAMvZZN93MvNYrHly/tEQC1Ulk5ZPPdywGFC0F3EifVV9TAtFmK25x4CMFOdPirYyE2pKIz/zej45lJKjRCoKzSz9OfyRxME4muwUUFS0DXbGfhCNPxPCyVAV0OxIktmOBx0LdTlk9lQCXe++7yXgOjb4IRPE7ndRcqKaceECTBzPSLW+9+v/gX8Joq5hTJD39LD/YU/JH/NoaGLEaqyIO5Dcr2isD7wSfOgv6vqSm8kmmTP7NvPXUl7fAWcMdgVf3v+YVVcF9IoVIkMO7du+fpUfTCD0znwEcc062o4HiVQP94XC2ziHgUZYOKIFfQSSF2vGH4+6ZBCXFWmTbptvm8F/YvAEpBOLz7dl0fqTAL7nwtgEeaguZWpD20EYvGEyBspmshOXEVlsZnYiT5l3xPgHsbuQD4BsN5FaKgJ9IzgGq4nWIuVK1ckFbx/jCwTxqEZHCoIxIdsVWoibh6kg0P05uu2IV83LSmPJlP9q8T0xx5C4cX5Ooie6/BmtmF3Y1dMHR2vnA60LzSrAc+X/3t387rWVlXlI0HpyXtzOR+zXn83jsDNr7LmNgdSVBp7REhfchT6Yy6vJxBP0nnk344YpCwrjahkJNmIT0lk7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199018)(38100700002)(31696002)(36756003)(82960400001)(2906002)(4326008)(41300700001)(5660300002)(8936002)(7416002)(6506007)(26005)(53546011)(86362001)(2616005)(83380400001)(9686003)(186003)(110136005)(6512007)(316002)(8676002)(66946007)(6666004)(478600001)(66476007)(66556008)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aThEQ2VTU29NaUJPbno1d0VUUDZ5M2o4cEdFa2tkejlxOW5RSVRkaEZnVmpq?=
 =?utf-8?B?MTZQQzZQek80bHZ3VmVRVzZ4NjBiUjhKMExBTHNkbmNzTHRVZjYxT0RYaWJs?=
 =?utf-8?B?MWVvMmFYRGxTU3ZYMTNwY0FrMGtJRElxMXNteGNKQmM4QU5IbkR6MFB0bW4y?=
 =?utf-8?B?ZWJPUVlqRC9FMXd6Zk93RldjSWpxNTdSazFiS3liL0ZpOEN5S2pNNXhhamJI?=
 =?utf-8?B?T0Erb0FZR0k4K2QrT0xHYnA3dWN4OUpxSmRXc2pKKzBwOFNxYXpaeGg4UGJH?=
 =?utf-8?B?RTY1emFoRWtteXdWaFY2U3ZyYkZGVFN0eGZGU1VjVlJQaUQ1OThqUzZFdGt4?=
 =?utf-8?B?a29lM2dTRks4OCt0bExkcHgvdFZ1Zy96bk51UE9TS05EOVB1MWlhZ0lvT0tU?=
 =?utf-8?B?cnNHV09rTGlxanVxbUhzL2hnRlg1aUMwZktSZjJuSTFvMnBPSk5wZjdIS0Uv?=
 =?utf-8?B?b3E5SG16TkhhRkhab3NqUlBWUEI2dlp1Q1R3alRhdzlYTWlQcjNwN216L1Zh?=
 =?utf-8?B?ZGNJYXplNHRPNFBlSStVYlJWZE9LMkRLTHR4aUt6b2VTRy9sMHV3MnVaQ0ta?=
 =?utf-8?B?U3dCWEtNZWhjTGlzQVBONU5BOVdNMVVBdDVnN3RodHFmWEFaSTdDOGdpaFdi?=
 =?utf-8?B?WWtRdHdBdXByN1JESEZQaVhWUVZMSnhRVDZDZ00rZkVOWXdRNWVtbGtjYWx5?=
 =?utf-8?B?Qm93SkhsSFlJekFKY2dqdG0zcUFHM2U5MFh1K0tTbmdteWNmdDBtUFluNUVG?=
 =?utf-8?B?aEp5WEJ4LzJnVWdIMDR4NWVYbFhhbnVWUnJzejNsOVJ2aWoyRjNKRlZENmRD?=
 =?utf-8?B?dWlYODd2ZmxVQmFjMndqUWtuekJQM3lBWlhYbzFEc3F6L2ZlMUFlM1ZXMDBs?=
 =?utf-8?B?WTc0N05JekJBMUtSUDlqSDNhNXR4dncybitHYk1hb3FIYVRBRm9BN2w5QTV1?=
 =?utf-8?B?alFLa1dYWUw1RG42NmNsTGlRdzVSZlE2czhtY0wwS1U3TnhlUFQ3NHpoTXIx?=
 =?utf-8?B?bCswYmpDVG1JbUN4SG4zNFZ5ekhicHdQc0lTM09mSjF4eDZjOUkxSzJYWWVz?=
 =?utf-8?B?SW5scVRMdkhDaFBmWjhDM1dYOXMwY3Nia1E2VkVrQktWTEp6TmhCQjRnK3N5?=
 =?utf-8?B?c20rNU9ubHhzT3ZCbjgrUTVsMndmVVVKY09IaUcyR21YaEd4bmNYRzBlczZI?=
 =?utf-8?B?TlplcnRIU2I5Z3lWNW56S2o2d2dmWEZmL3VSNy92MTZBR0lUaDdYQzdxUjA3?=
 =?utf-8?B?ME95QzJLNFIyZWkwSHFQSFFWVjREbkJwcUFjdUdKWENpOFMxc2M4endoRktn?=
 =?utf-8?B?MCsvb2hjbER6bTdtN1FFQllaUG1qMTNtYWdQZE0zV3pjVGJXaVVCWC9RaXdv?=
 =?utf-8?B?V3NJeVpIZ1huM1M2ZnBIMnc3Z2ZwODhQZFJvcmZzWS96RDBUckhkU1pydGpo?=
 =?utf-8?B?SXF3REVjRERUTnIyVm4yTG4zMVo0a1VPSGVSUUVaMmxoU1hwN0I2bXF5VjQv?=
 =?utf-8?B?YU1vZlNIS1hJdEtmeS8yaE44VWFEbUtqamg0Y1B0N2tyOXdTTXNSZFB1WnRW?=
 =?utf-8?B?dUl3NVBmQmNxM1hrTmdUWFNqSkJXWW1QMExDdjBkVnBQRkszeEhOb0dydCtO?=
 =?utf-8?B?VmJHV2RYcUo2aXU5TU1tc09XS2NyWGRYRmVyT21zcjVLTGFGZE1IMWUwVHVT?=
 =?utf-8?B?M1RXMC83NWg4NlZycitUVFRXcEhIcWlsZFJNMnRvQnE3MWZURzJkQ1dvSFJq?=
 =?utf-8?B?bmRkUS9yNmtUTHU5a242VVZFUU9IczlPSVFvZWNZbFkxL0JXOVhadUtiVGRX?=
 =?utf-8?B?MnZuRUdsZnArVllnYWcxUkEwOTB0ZVVSYkVGMlQraDNRRjZMdStQS0trcmI0?=
 =?utf-8?B?RXdjK0lMa09URlpCTElLRlByMzRacmxNNEtRcjBNcHBDUHdqMk9wZU5rWmUx?=
 =?utf-8?B?TlhqS0JML0NKMWdHc21CWUZkbEljaDh2aGt4UzM3SjhwWVlBSGtsd3dsOU9H?=
 =?utf-8?B?eUl1VWRtWWdrelZzNHF2d2FYMFBjNjlEdVZ0bFA1czV4cXYwRDdVamVHWndL?=
 =?utf-8?B?Z2paUHVkNHg2TThaWjQ1ZlRCSnNxa0xvTTRJbXRnRGZhWFVRSE9HWFNwbUda?=
 =?utf-8?B?anJBTWtxRFA2WjBZdW81UDUzeGxVUnc2NGpFZzJIOUUrR0k0RkNNSS9WdTFX?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZEhBMWZZSjlaUWVXWU5RbXBaNWhHWUtIUm1JRE0yOUdBN2tSN2VRNVdUcjJZ?=
 =?utf-8?B?NXdMaXNBY0xRRit2c3NReTJxakhWUzRHRjdlV3ZTckk2ZGJDeHYyaHVoMFpt?=
 =?utf-8?B?RVVKakQvc3hMdjlMSXNiZG9NUWVDRHc3d0hsWmNaczJYT0QrRUNaeXpTREJW?=
 =?utf-8?B?aW1meVJ1VVhXVitPRC9rRURVcGZpNXBDWHBXWjUyYTBnQWNTYVdkbFRYbU05?=
 =?utf-8?B?Smh0Y1dKWDM3eHRsYnFNNGdRUmdwNEhRVnhSVFBzMC9vdkdqTWZOWjRJSWtZ?=
 =?utf-8?B?VUQwaTFZbTI2TjhnMVYyUUt0ZHp3Rkg1bXpnODFobG9heTIzY3dYNlV5TlNC?=
 =?utf-8?B?Y3pDWlIzcDN3elUrMk1WOUNXSW9idWlWMjFRUVJIVGU0U1hCUjdxSjI0U214?=
 =?utf-8?B?ZGMvak9sTk94VzdEMUxlT21VL0Zkb0pma3lWSjIxQ3lqZS9qQnR3cTFMUlZR?=
 =?utf-8?B?V3NrZFVEM1hPMkpiRVVOcjFUampNeXJwQm9zUlBtVjYwY21tdHBnTFpGWHlC?=
 =?utf-8?B?M0pQMmhHTVZBWGtEVkNJUEdHZi9ab0hycDYzNUppVWdENGc4ZDdhU2VSK0Jh?=
 =?utf-8?B?dndxS2ZLQVd0d0RSbFV4ZUNubmxhV0RpZ04yNUo2VWtRc2d3eHp0RGRpcVFJ?=
 =?utf-8?B?djh3YVFuUWl6WDlHQ3pQT2ErRUZ2S2pMeWw2eVkxeVZITmNlbmhSY2JvTmZo?=
 =?utf-8?B?ajlocWJhNHMwWVZUN1gxYXBPQWw5Tnp3RmVrVTVUWXNka2xjYUJ2dVp3RnFL?=
 =?utf-8?B?YmtaeGR6cFhFRC8wRDNKYUNZZDRHd1ZFRkhzYnkzb0VyNDlvbEpWdXRwOE5Q?=
 =?utf-8?B?UTNyUEZyRVFpLzVZMU4xVkN5bzlKMjkyU3gyNDhEc2YzZDU3UCsyVUFVSUh3?=
 =?utf-8?B?VGloSWtKTThPVzZBTC95VWhsQjZqemNqOFg0ZVdSRzJJb2N2RmJkVkpVYStT?=
 =?utf-8?B?U1VmRGZabGc5UnRJbFdvV1BDd2lDNHVlS3dYMnRuZjZJaFM5aDlUY2dRVG5S?=
 =?utf-8?B?S0VsVXdJRUloNW5FZkVidnRBeFJiQzlFMXp5RE8rcTQ4Qkl4Sm9wOUJRcmRo?=
 =?utf-8?B?QmxDUGJubGFYNDNIa2p3YkJQWHo3YjlvTEpsYUFVaHhxMDlZbmVFcngxQUla?=
 =?utf-8?B?b09yV0Z1a1NXSWlycGdMcVU0bmJEaEE4ejVFZ0JVY0pjVGp5SW5DZngzdzBv?=
 =?utf-8?B?ZFFyMnlvbmdpb01QYXhLQ09GNHcvVWp4SlNpaHh3bTFQUEpROEtTNGE2ckxl?=
 =?utf-8?B?ejF1RWxyVUU3NzFZZmtXc1R6aHM2Q3JuRFpDWEl4UExSVlpKdHdxdCthSnVB?=
 =?utf-8?B?NWlKYk5CbEcxSWVEcXZwUS9Ydm14aVhDRDdkVjZXNDFtdDJ2ZTZvNnZRWHZD?=
 =?utf-8?B?ZEdEdTdtTEQ0OUFlYWlyTDVXUXhKVUQ5c0hVcUtCZTVFK3pSenFqTklkeXg3?=
 =?utf-8?Q?Zqn9NIFn?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad7c4b4-e7ce-42d2-78cd-08db26cdcacd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 09:55:52.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEiFgZ6JMNNZ4mm9ZkfP26GDawa2ajvPziLLSeeM8Bj1AaDSRIk0xGs9t6Iz4owq5EEjhU83eE+8wE+KXkJQrLiqDUba6Co2FZFqx+aSL0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR03MB7210
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/2023 9:39 am, Lai Jiangshan wrote:
>> +#ifdef CONFIG_X86_FRED
>> +static bool ex_handler_eretu(const struct exception_table_entry *fixup,
>> +                            struct pt_regs *regs, unsigned long error_code)
>> +{
>> +       struct pt_regs *uregs = (struct pt_regs *)(regs->sp - offsetof(struct pt_regs, ip));
>> +       unsigned short ss = uregs->ss;
>> +       unsigned short cs = uregs->cs;
>> +
>> +       fred_info(uregs)->edata = fred_event_data(regs);
>> +       uregs->ssx = regs->ssx;
>> +       uregs->ss = ss;
>> +       uregs->csx = regs->csx;
>> +       uregs->current_stack_level = 0;
>> +       uregs->cs = cs;
> Hello
>
> If the ERETU instruction had tried to return from NMI to ring3 and just faulted,
> is NMI still blocked?
>
> We know that IRET unconditionally enables NMI, but I can't find any clue in the
> FRED's manual.
>
> In the pseudocode of ERETU in the manual, it seems that NMI is only enabled when
> ERETU succeeds with bit28 in csx set.  If so, this code will fail to reenable
> NMI if bit28 is not explicitly re-set in csx.

IRET clearing NMI blocking is the source of an immense amount of grief,
and ultimately the reason why Linux and others can't use supervisor
shadow stacks at the moment.

Changing this property, so NMIs only get unblocked on successful
execution of an ERET{S,U}, was a key demand of the FRED spec.

i.e. until you have successfully ERET*'d, you're still logically in the
NMI handler and NMIs need to remain blocked even when handling the #GP
from a bad ERET.

~Andrew
