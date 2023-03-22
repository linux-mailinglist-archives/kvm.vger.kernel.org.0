Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE5D6C59FF
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 00:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCVXEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 19:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCVXEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 19:04:10 -0400
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF7826CCB;
        Wed, 22 Mar 2023 16:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1679526249;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QYIHZKv6mWUbhLJnejKYnsQ+iIl/VW/fv5LtqgRByz0=;
  b=OUMX6H+d43sojnEWb6DPHIbUQYfnu5vu3M+hQsbAnitY88HIHqX8VQL5
   srICPqwKB/gEQRVwt8uxeqhVsE6z1ABV8mc5oCvU/DBUcIYybth+Oc8uD
   gZ+95NHifYN9gpsp9u0p9oVHjWyh4Xs0Vq7q/kTD7LwXaS5xUUWiiCEYz
   0=;
X-IronPort-RemoteIP: 104.47.58.100
X-IronPort-MID: 100735413
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:BTjNrK9uRMPtImdF30UGDrUD8n6TJUtcMsCJ2f8bNWPcYEJGY0x3y
 WYaW27XPvyOZmGhfdElYYi1/EtS7cXXx4c2TVBu/ig8E34SpcT7XtnIdU2Y0wF+jCHgZBk+s
 5hBMImowOQcFCK0SsKFa+C5xZVE/fjUAOG6UKicYXoZqTZMEE8JkQhkl/MynrlmiN24BxLlk
 d7pqojUNUTNNwRcawr40Ire7kI/1BjOkGlA5AdmPqoR5AW2e0Q9V/rzG4ngdxMUfaEMdgKKb
 76r5K20+Grf4yAsBruN+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+v9T2M4nQVVWk120c+VZk
 72hg3ASpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn9IBDJyCAWlvVbD09NqbDklS0
 /NJKi8ESyuFqLu47Ja9auh8hdY8eZyD0IM34hmMzBn/JNN/GdXvZvuP4tVVmjAtmspJAPDSI
 dIDbiZiZwjBZBsJPUoLDJU5n6GjgXyXnz9w8QrJ4/ZopTWDilUpiNABM/KMEjCObexTklyVu
 STt+GPhDwtBHNee1SCE4jSngeqncSbTAdpKS+blqqcx6LGV7mMcN0MLU3alm/W8pWCsctkCO
 X4Q2gN7+MDe82TuFLERRSaQu3ONuBwXc9VXFOI+5UeGza+8yxaYADNCSj9pado6uctwTjsvv
 neNntX0FXlsvaeTRHa16LiZt3WxNDITIGtEYjULJSMVs4fLo4wpiB/LCNF5H8adjcPwMS//z
 irMryUkgbgXy8kR2M2T4V/Dkxqop57UUhQy4ATHGG6ohit8ZYiqYKSy5FTb5OoGJ4GcJnGLp
 FANn8mT6rBIAZzlvCCEXuhLHLiv/PuDGDndh0N/WZgn6zmpvXWkeOh44Cl3DFV4LsEePzTuZ
 Sf7oQ5N6YVBFHqsY7V+b4+4B4It16eIPczvUfbGb9xPSoJ8eA+O4GdlYkv493rkjklqj+ckO
 Z6dcs+2JXccFaljijGxQo8gPaQDwyk/wSbfQM79xhH+ib6GPifNEfECLUeEaf0/4OWcugLJ/
 t1DNsyMjRJCTOn5ZSqR+okWRbwXEUUG6VnNg5Q/Xoa+zsBOQQnN19e5LWsdRrFY
IronPort-HdrOrdr: A9a23:NHsDoaiW//cLcKpky3uQkWCiTHBQXuAji2hC6mlwRA09TyXPrb
 HIoB19726WtN9xYhEdcL+7U5VoLUm3yXcX2+gs1NWZMzUO41HYSL2KhLGKqwEIfReSygc378
 ldmsZFZOEZojJB/KDHCKXTKadD/DEnmprY4Nvj8w==
X-IronPort-AV: E=Sophos;i="5.98,282,1673931600"; 
   d="scan'208";a="100735413"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Mar 2023 19:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJon886s2NGDFoIwV0OskycfqMxgFtMCKob7MaNG5ZIkSZQU75sdMTtVbfpxQASLXtk7a1R0xspJKvfWaYMGLsvnTujYsUT9sZruxoMkG3vBKA6bHFbD3Byc/hllz7CMoNFxBVqvvDra6Xo60Ba6XJxapBdjwpxT3bYRdC9DLGZXtK9deZCVYCgYrWuLWUuEUjIhX58r+7pz292ImpukwCNBklDUIXK9ikYfRA088MY9cKEIQlvu83d7qoHLcRK9FUvZkuqmvYk3CU9NHoV5sFBT7jA4++Gz+bB2tOjivqqQGpjuScjsep2vRoYB2xi5mzjG2Q3XeVHynWM6DS6h2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hchYzloUSFEi163u0tL2kx/nx+Ylbdbco5m8jMuuxN4=;
 b=OaM+5MJJi8pbG99mFhwRRwnO1R01wgbwL+PVfT4edTnXlpMf6cjfmoDzjiWP5rumxaA2I7ULZ925xJWuEpaoqno5ZHnS/fve+5Ywkuh0NMKA6W6ZwNgrHBlX95ValLCRKWk0Uepv3PdNP/AKPHKzypmeGQzIdNmGYFT2UzkiYqCxtpq4JysDc/1Pjuq4ioWQoIHi1QX0GTaYVoGzGg7Wwu5B4KwOgQBbWCQS7C4ELu4Wd7YlqLr02wXf0xXOo7mhEQEPNn8BWzcKRQLZRcd9blkswAIzHpWmmfOoGU7HNPntIwXazf8x9bhBlss5aCIF79vtlxNf2IGkzNThzYIdgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hchYzloUSFEi163u0tL2kx/nx+Ylbdbco5m8jMuuxN4=;
 b=Y1nF5lDRGRdwFSmwbO5QAMcG0oW+OvA7l/cXR1mrWlPbAPYhe+VjwytDIzQHwx/5FyPm3f6Uk5zK2Js4jqFV9mikljsJjPIgTnOA2hqsnVnwSThVUeSerDMNVlEgQtq074BwPjUJ5XlxyUj4RX4+DfG/ZHFumKcyCY3J2xr4b20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SA1PR03MB6531.namprd03.prod.outlook.com (2603:10b6:806:1c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Wed, 22 Mar
 2023 23:04:03 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 23:04:02 +0000
Message-ID: <c9abb017-0088-b96f-d19a-b25e54ad150d@citrix.com>
Date:   Wed, 22 Mar 2023 23:03:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   andrew.cooper3@citrix.com
Subject: Re: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>, Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        pbonzini@redhat.com, ravi.v.shankar@intel.com
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-35-xin3.li@intel.com> <ZBs/sSJwr7zdOUsE@google.com>
In-Reply-To: <ZBs/sSJwr7zdOUsE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::28) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|SA1PR03MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: b73823ac-40df-4bf4-e69d-08db2b29ba5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knDDhxwdE7Pk+9wWAjvDklTzipLBplkz6KN4j9X8FCHf+3gyBw5kkYvGsqSyetCq3rezH4OsxRpj4a5VSTrb73U/SaHCO16m+QChc0fiEvgLouWss3SyDa2Ghgaort7GaJmqT7Uw2mBwJ0VkKhEOjQwtvsdWJ3GJQCY691lPOrElyBSNAfn/ai952Ds7e+Tqc5sUWtPhAKTat0HiC2UP1GqnP4fsQP5r8AR1AQcYRHj1onwjGmy90OjLpH/IKeDAVY68DKkDoOfHFHEftNDwNybIbwQPYCIa4IhPs3dsdIbsFgE3bBZqUguDnxnyWCk2TtkXdye/NA1CzOlsELlpBkwnNPGGW5aBG5FTUDWR0dWrql6iuWr0ETrzJItJCP3AEW/qT8RC9OVFi426rDpK88rXqDBCydUqIYwOIBqe98kmDXa+QWQxMiASP7ExMFfW0DZS7Bvljr9UOjlOInOCA46Tn50/ftkEAqrU7PdRQesVDgp4mGlf5xSsMaFX6Y/pOFzuXZHxE3hK6ng1gifhf+cKOy2SNS5ziglEChZqaJj1YGF1X4zCtZLpgndYxUG5KqZqoPwpdVDlh7TdWec5vMywzw8oEaFdeFnQkllT0+ybjrgVSv+dI5DZuQG7s6bP0ohLhcsTI7hjYprKiXOi4+e8YfmJCk0vAkmKfi0UzvYFF5JfEC+t58+zSg46km3iE8xHHLee+KBRDZw4Jn4v5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199018)(110136005)(41300700001)(186003)(8676002)(9686003)(4326008)(38100700002)(26005)(66946007)(6666004)(53546011)(6512007)(2616005)(66476007)(6506007)(4744005)(8936002)(7416002)(36756003)(86362001)(83380400001)(478600001)(316002)(6486002)(2906002)(5660300002)(31686004)(31696002)(82960400001)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWNsTDEvZlVzNzNXR1Ayb3k3dmJVa3JnSjhzN1lwQ0tRdmR6Ly9aWGV6a2Jn?=
 =?utf-8?B?NkRVRG1XYktEeUN0L1EraDMwWEovemlPR05zWDU2Mm5jL21DNm91UzJPQlMv?=
 =?utf-8?B?RUI3U3pZUDlJQUM4RVVzQm9peTB0UDB2dVdya3lzSUJSZ1Q3cmhxUWd2Y2hz?=
 =?utf-8?B?bk5RajF0VmtwWU5JRUJ2OG50RlFKR3BNaWQxMDUvdGZvQVVsd3FTcE96NFky?=
 =?utf-8?B?SEFmYkxGWjNtSFcrUWZCQ1VpM0xWejg2QStDRGhHdEtCZTJlRGg2bmVSelEx?=
 =?utf-8?B?OEQxZGI2TXpOUEFJeXFBNEJYYnRKVGdYakdDRE9CZnJSY2NrVUQwYWZsUis3?=
 =?utf-8?B?NkdwR3NBUDFkTEo4MWJHa3BxWW1DRHk0Sk9MMWlSVEQ2aUtwWFRrSG52WEdD?=
 =?utf-8?B?RzR2NjNVOEE0NnZHTEtVT1ZvU2VKU0JETjZIeVFsR2JHNFd1UmhRL3NqSUxL?=
 =?utf-8?B?dlBxNWtXaE0zVGtPOUV3N1RpRkNWV2IvUHNsWmVCcUc2eTRwOTRlbDZDN0lv?=
 =?utf-8?B?dHkrdmtsci9vTG5rRjNsRHEveDNUV25WaFd5K0w2YW5JeWJSNjRGRkJ0dmFR?=
 =?utf-8?B?Z3RwYUtlRm4yakt5ZUREZE42RzRjUmlBS1pvdEEwV05qcE5ndFE3TTVGM25G?=
 =?utf-8?B?ZUdyZ041ejkxQnpJQ043dzZ5S29GQlJpZ09Ic1ZXWnZqeVhwNW1Rc0VTZEh5?=
 =?utf-8?B?OHlJRkw2R1BUcC8zbmNXZXhBMzU4M2ltQmw0dW1GcDQ4eW1QM1ozMjdJRFla?=
 =?utf-8?B?TTZ4SERZcHVCM2ZLNndWRjJyNUs3NWhNRXhKN0VhdFBMY28xeTRJUmc2Q0lW?=
 =?utf-8?B?d2V1Y2s0ekxEay9LY1hXY05vRXVqNGJHMzZhSW45R3A5VEJERUxyTGxnZHhW?=
 =?utf-8?B?SElkMDdqRmlPa3RhVmx0SHNoS2NCeHJIWWQxLzFpSVQ0NnlBc1EvUUowMWMz?=
 =?utf-8?B?eGtIUHRoWmdjTTR2U2pQcDFaaG5RMk1GVEFjY1NXYjc4YmkvY2Z6YmtiY20z?=
 =?utf-8?B?MWMrQTliN0ltL204TlZNV2FlemYvRGFhd2tMM0lZZjh4cW9sVVpZNnlZcllv?=
 =?utf-8?B?Y1hPZWd1RVZGRTQ3akN1VVNpV1NQb1hpZ2pVanBrZVJEZURKTUtZSkQrNWJv?=
 =?utf-8?B?QWJiTEVFYktjNHlPKzBlZGVFQlk4VWQ5alRyczk5TlhjU29jaDA3TEM0T1ZM?=
 =?utf-8?B?M0RIUE82Uis4eTVpM0hyNFgxN3o3bEs1K0NxZXhsZThpalV6ZFBSTlcwcXpK?=
 =?utf-8?B?NUpuQkl5SHZKNmNPNFJlVENFdlJMaVdab2NicXZrYzN4clVwb3czNUxJY1l5?=
 =?utf-8?B?MFFFVUcvd2dNdWNQRFJCTThMVEpGem1YUFhzaGZuOWMvd1UvNjRUWndpWkpT?=
 =?utf-8?B?UVQyZGRhL3pFTzNwc3JGdlB0a2Y3YjcrM21MdUFBdENQcERidWFCMFovRTU0?=
 =?utf-8?B?T1ZWdWRud1ZObE5ZM1pjaVZLdVlMNXNrZUNHV2I2d2lNNDArOCszcWQ0bm1Q?=
 =?utf-8?B?TmFKWFA2bzBtZHlQcWpjVjU3SUkvNWRYVnpwMHU5M21kOGl5Yk5CZ21BREhj?=
 =?utf-8?B?b3l4aXo3djBlckNkUWpIOEpqaWlDcHNWUlI1ekpzY3B1VVhVbkpIVEhIYTgy?=
 =?utf-8?B?Mmc1RWdKZ2ZWdG9BMThnRzZRbC9KdjcyblZidk5lWGYvTXppeCsxVEIzcjFi?=
 =?utf-8?B?MWhidzl3UXc5a05WSGVXSC9SWVhpM2RMcEFhdXMwd09RUE5DdGJsTTlwNEh4?=
 =?utf-8?B?NG5jdXhmbTRGYkEvMDVsMjRNajczamNraUJCaVRSVUszaXJUbmJTUU5QRUpy?=
 =?utf-8?B?MFF2a2RsQncrWlhXSFhDalZCZ2FIc00vN0xRZTRPSnd5cGo5WS93VmxMM2U0?=
 =?utf-8?B?cWV5VlRDdjZQUE1UeVZGQm5wVDZ1Z3g2b0VwREZCQWxjSkE2bmVobzIrQk52?=
 =?utf-8?B?YnYwRWg2YXQxbGZGa3VibnNaQlpacGs3ZUdQcnQxQVdkVzRINElPWVJrcHhB?=
 =?utf-8?B?TkkrNlpEVUpJdElmb0QzNU9TQ1NEMGcvK0JESUxMb3I4Yms3d3NWcmoydHNJ?=
 =?utf-8?B?SEIzd1VoSWI2Qk5KV0lzZXZ6eW1XMlRYTm9BdGJTSngyT212anpibzN5bGtl?=
 =?utf-8?B?U0sxTWZHMm81eDk5RU9yTTZDOTQyYnhzaFQ0Q1VUM2JjSFZOT1dWTDVWV1JC?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YlAvVGhHVUJFNlZqL281TFBRNkswSEhMUnZxbDgrS2RqVFppcSt1NFk3TE1F?=
 =?utf-8?B?R2doeC9wNXFOV3p0MmZ4czU5VUhPOW1lWFpPRFl1U0x6ZzB5Tlozb2hlYWRK?=
 =?utf-8?B?U3BFUTNmUzRtOS81NXpXRzcwOWdzblM2ZW9KWEFya0ptbEZZOUhNOXBFdFhJ?=
 =?utf-8?B?MmFmUmxiRXUzdWxRZWRFVlR3aWNNa2YzdkR3TjQ2RDRDREdkYlpNUFYwczU1?=
 =?utf-8?B?QnVaeUFZZ212U1hMOStCaTc1SlJrbHJYeGROR0xtc3F2SEdjTFRYaXZtUWpC?=
 =?utf-8?B?cEtRa1hKeGtqQkxGa3JqTkZjdnkvZ3Z5eE56ZUhrbXhlSVBPV1BWbzVuWE4v?=
 =?utf-8?B?ZFUvWmJ1OVVHT1EvTU1HRC93VTdXL20ybFZQVXZPUTZwb0orSEEzNnBRcFFW?=
 =?utf-8?B?K2ZUWWliSTdoU1E2OFNDbmluV0hLSEViN0RLdUt1QmRsTWlMc205Zk91VVpV?=
 =?utf-8?B?a0NsUFVJZTdNT1ZxUDgzM05mVEVrSWVDa1E1K2JWMERiM1JBSXUzcnMzdWgr?=
 =?utf-8?B?cnR0REpUYzBZN1dWcTRvS0l5d09MeFY4MzJxSXRkL3l4V1Nva3VVQXdlM21y?=
 =?utf-8?B?K1RtMlZIbGl4aUhOMFExdFRob003a2VBL1VybWxHdy9TcHNhOXozcWxmQlp0?=
 =?utf-8?B?bHczRlhPOVphLzQ3cWsxWE44SldGWEZqbDdlMEhueEoyNWprcGJRVTZXekdG?=
 =?utf-8?B?YUsxTkdJckF5clNRa05ZM2lYa1NYeTBxaTRyZlJRU3hkbklRT0Q2MGVSMEdI?=
 =?utf-8?B?M3EzL3RTU0diSjFBMEk1ZFRvYmlYa09JbG5YQUZubVlXWkY4ak8zRExLOU1W?=
 =?utf-8?B?L1R6dmVYRVo2YyttOFdsK0F6enZPbXhjd3VsQ0NQRU15ZkM4dHBVVWZXY3dW?=
 =?utf-8?B?cTcyQi9XNWU2eW8ySzVnMU4wYWlOV1F2UU45SUU4eVlWa2lGL0hsOEV4cnBm?=
 =?utf-8?B?Tmwzekg3Z1lGcm1tS0hkZFI0VDVjbFc5eG5ERU5scHVqSUFveUYrZ3U4QjBJ?=
 =?utf-8?B?aHJOaTlHRUZERVlvWFg1eHRWWmsvbU9HWlZxcFNNUHdGdzRpQXJicnluZzEz?=
 =?utf-8?B?dFBzallHMWV5YnR1Z0JqdU92aEtNOWd4SXR2UEN3VWRGSTBlTW9zS3VzZzMx?=
 =?utf-8?B?YkNWYU1hbmF5QmV0ZTNtaW4rYVU0Nm5WM2wwNk5ESG0vRnhqMlF3MW1RcXlE?=
 =?utf-8?B?Z2FnRUliMTlabE85RWJLeG45cTU3TnUyeXg3dXF3cjJNTkEwQWlmTUJIOGtn?=
 =?utf-8?B?bWpkOVIyU0V0SFVydU5QVWhaN2JoTXE3ems5RWxsUWVUS3dFY09HYnpCUjJi?=
 =?utf-8?B?VVlqSkpHNWxTbUt6UGorRWh1SU1CQzBWQ3VBaWZjbkJSR3dBaTBiSG5tV0ps?=
 =?utf-8?Q?mndAKaQOD2H9AeKpFwsB1+ZCNRlqPPpw=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b73823ac-40df-4bf4-e69d-08db2b29ba5a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:04:02.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwV6slKiAsiN9lPyRSqOCCVRqGpugVvGMmDraZVaCQQTP50+AVgjngvhAVfFD/4CzCAUXW5LW+iyIdjPEciFxNz9KOJsRL4i1emmiW0abJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR03MB6531
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2023 5:49 pm, Sean Christopherson wrote:
> On Mon, Mar 06, 2023, Xin Li wrote:
>> Execute "int $2" to handle NMI in NMI caused VM exits when FRED is enabled.
>>
>> Like IRET for IDT, ERETS/ERETU are required to end the NMI handler for FRED
>> to unblock NMI ASAP (w/ bit 28 of CS set).
> That's "CS" on the stack correct?  Is bit 28 set manually by software, or is it
> set automatically by hardware?  If it's set by hardware, does "int $2" actually
> set the bit since it's not a real NMI?

int $2 had better not set it...  This is the piece of state that is
intended to cause everything which isn't a real NMI to nest properly
inside a real NMI.

It is supposed to be set on delivery of an NMI, and act as the trigger
for ERET{U,S} to drop the latch.

Software is can set it manually in a FRED-frame in order to explicitly
unblock NMIs.

~Andrew
