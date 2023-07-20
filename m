Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B78175AC44
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjGTKqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 06:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTKqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 06:46:49 -0400
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CB2171B;
        Thu, 20 Jul 2023 03:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1689850008;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fr3F1IRLYOlXcVr90RqMRwnValvnVJKZcZOrR7O5yDk=;
  b=UTZkc0YMe3I2RBlA/Wf+6hkJuqtexjNUWAJumUOHeHxIUVkhd5sZ4QL4
   3PdW3CPmENEYTosNq47k5P5JBhlN20V0QH2KXWqljTSCX5JNez/u5pIbe
   cV72cZa0HT95o+HCQg7Qw0UTDwbSLkoDy2bPfK5Ipm3Xd/b/IkX4KGOII
   I=;
X-IronPort-RemoteIP: 104.47.55.100
X-IronPort-MID: 119454221
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:u9BZrag1b2v+XyHL6ygR6uiOX161ZBAKZh0ujC45NGQN5FlHY01je
 htvXDvQO/3eM2LyKY11bt6w/UwCu5PTz4cyHgJo+XhjFikb9cadCdqndUqhZCn6wu8v7q5Ex
 55HNoSfdpBcolv0/ErF3m3J9CEkvU2wbuOgTrWCYmYpHlUMpB4J0XpLg/Q+jpNjne+3CgaMv
 cKai8DEMRqu1iUc3lg8sspvkzsx+qyr0N8klgZmP6sT4wWGzyB94K83fsldEVOpGuG4IcbiL
 wrz5OnR1n/U+R4rFuSknt7TGqHdauePVeQmoiM+t5mK2nCulARrukoIHKN0hXNsoyeIh7hMJ
 OBl7vRcf+uL0prkw4zxWzEAe8130DYvFLXveRBTuuTLp6HKnueFL1yDwyjaMKVBktubD12i+
 tQFKxQdUgC4jduyzZ7mFsxAlvU/dO/0adZ3VnFIlVk1DN4AaLWaG+Dv2oUd2z09wMdTAfzZe
 swVLyJ1awjNaAFOPVFRD48imOCvhT/0dDgwRFC9/PJrpTSMilEsluG1aLI5efTTLSlRtm+eq
 njL4CLSBRYCOcbE4TGE7mitlqnEmiaTtIc6TeTpqqM22gfKroAVIDMIDUuGnsWotmXgQ5Vwd
 GU41woVsLdnoSRHSfG4BXVUukWsphMAVsBCO+w85huExqfd70CeHGdsZiZIbt8vtok5WCQ23
 xmNntX0FRRgtbSUTTSW8bL8hSi/MC4XJkcNYigLSQZD6N7myKksgxPNT99lH+ikh9v6MTD23
 z2O6iM5gt07lcQM0be6+1HvmT+gppHVCAUy423/XXygxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBmMWE6u0KJY+CmTbLQ+gXGrytofGfP1X0m0Z3A7Ei+i6r9nrleppfiBl0JUFjM8BCZiLBZ
 E7VpBMX5ZlPMX/sZqhyC6qrCs8pi7CmGNjqW/vTa9BDSpl3aAKDuippYCa43Wftlg4llaUyP
 7+SdMrqBnEfYYxszDOxAegU1pcqwDwzwSXYQpWT8vi8+b+XZXrQTKhfNlKLN7g99Pnd+F2T9
 MtDPcyXzRkZSPf5fiTc7Y8UKxYNMGQ/Apf17cdQc4ZvPzZbJY3oMNeJqZtJRmCvt/49ejvgl
 p1lZnJl9Q==
IronPort-HdrOrdr: A9a23:cL/gAqFw2IIWzjGgpLqE0seALOsnbusQ8zAXPhZKOHtom6uj5q
 OTdZUgtSMc5wx7ZJhNo7q90cq7IE80l6Qb3WBLB8bHYOCOggLBEGgF1+bfKlbbdREWmNQw6U
 /OGZIObuEZoTJB/KTHCKjTKadE/OW6
X-Talos-CUID: 9a23:l2iGo23ZkDjtAsqvS7Pj5LxfB8MBYkHN933pJ0KUVDpMZK2kVQe25/Yx
X-Talos-MUID: 9a23:xneThgkftnrTjE/yJpN3dnpMKp943puSGXwmz41BlJatGQFQACqC2WE=
X-IronPort-AV: E=Sophos;i="6.01,218,1684814400"; 
   d="scan'208";a="119454221"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jul 2023 06:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIMXcTfcijv8QVYnHU/QtaxhU51ny1gxKSwvQ/NRDNnmC1Sh77j/+cl6eZx05GtoKsR3v6GypS0CFIiLh4lP1sPrpPhPWNaQUY8J7AAuKdvr8qDUKUBs/bB4IOJynbHlMbD1J3YACLpXilFQCy/ofWQElPfoxTaM8HWUkZroDefHWFd4N52K2+K4YWH7RcZoCopm/ba3Rpk4ZcMJpVRZe6e0KTVSfuB+frRALFjSiqGBitCmQ6SQ2Pa0QQDntJjvC23bcS5bfwT5VWmJJgLOVckR28rzI0obku/84mzsj6z4Y1bb7MyBUmxgq6CPfA6KTW3p+ZRAfr8DznJxrqXUsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/22W+hE0/77hCR67qeKYcD0WarBw1mw7ZGnPvJvpLo=;
 b=NIPnLfDHgeZSC+FUMp8X2Gjul6BMAyeY/rElwlyjDjSmkgNZNgfJdf3NV6CUPH5Z018KBJMyRvPo1eNKIlBGqFs1iUtzXnpteL++9pRiLlHGOflEEEkW7iR0rysrs5iSkTEG26+24yqvmqDOZQxAYLToMj2BFXF9T5oUSRD1NRbfDmH24pTs4y+uxd+cyx6SVdu99yyMP0zsMRxqyHHZSD6wav7LYBcAN4873q8P1cg9JLYh1iLCs4MAQC8nnVTUEURyXYE2VeyYH758reYKWC6wBgs4SiMjty14u2j0U7WbM9S6ebSqueyoH2V2uaRdDoGq2FMFfGcpX6kzDIM0Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/22W+hE0/77hCR67qeKYcD0WarBw1mw7ZGnPvJvpLo=;
 b=ABld4+abLjRJtjJV66Z8YfPKaMJ1f/v9HSCDWu8IaSDF7t+PQ5gA/XcpqYJ7YM4unfQoChmSVbEl4n6Yj5+48e39rNzQq/tW0APfHORxIxUaCPyW473tUnazDlhUwfbcOZypFzC/YLFXDCC8qm3Lk6OIlYQXnTKzY+S4S/BvURQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by BL1PR03MB6183.namprd03.prod.outlook.com (2603:10b6:208:315::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Thu, 20 Jul
 2023 10:46:43 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::ea9c:844:91b8:a780]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::ea9c:844:91b8:a780%5]) with mapi id 15.20.6609.026; Thu, 20 Jul 2023
 10:46:43 +0000
Message-ID: <5fb766cc-837e-4fdf-f1b2-5498e89297f2@citrix.com>
Date:   Thu, 20 Jul 2023 11:46:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
Content-Language: en-GB
To:     Peter Zijlstra <peterz@infradead.org>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
        binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com,
        john.allen@amd.com, Chao Gao <chao.gao@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
 <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com>
 <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
 <CAM9Jb+hkbUpTNy-jqf8tevKeEsQjhkpBtD5iESSoPsATVfA9tg@mail.gmail.com>
 <20230720080357.GA3569127@hirez.programming.kicks-ass.net>
In-Reply-To: <20230720080357.GA3569127@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0646.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::15) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|BL1PR03MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efc393d-b6d0-4a75-e7d9-08db890e9ae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEmxywdjuSX4KJGtMkbR14qyGJUqi55akrjTp0/K6C/4Aaz0oE+jMnaoiH+pUcfoayWGzaPzKNkBFrtZ5CS3AoMQItJ1Sj2yHHsM93gyi/DuSFjzhcsCBwiKe65he2gF782KQ84LbITBagr0yNxnoug8BEHmzqh+GKV3h757bIdJvOESSDGbdTKVD+XEfnq/n4DLXiYsHprn1Rego1l7tDJUyVN86U46KRFdC55nSA2kzo3jKiU51UQYQyjYKuCpjDdQHuu8Ld037ZJWfn1YPNjT6q3Z3lOBsz29PZpQQpaONixEHQ8PRPqgJRPBKToepDwK13Td90ZiJmtgZjGjaBHHZ1UzYofJa/Xt4HaZRsL1xxuTK0CcmKuPTkvZWCFEU2f1Eg3RpHy9aNRcgi1TrhK+0HrK5kXpbJIyd2x4sji0CGGrtU3R4rb8/NwtNQxGnuFxLoIX6IKAsdVsUum7dIvCh908mOHBuvSY+XIa3eiyC6iwTExdh3bYRByf37OVNcgS+chVvMDrSCJdlc+PkgUaso14i2R/Tjck1QvYEUTBAhvBxfDfnXEEkDU8aDnE8j2fGYaPtubEvnTmPfJMP2e9RzXhXGdIs4MOFJZv6rw6d4M3/F58bxSYUi8nKb4iVKdfh6Sg2NlXCajbrEUQlG1TyTSPhiml/yJALOHpgHey+LxNk2Cy37blPOBEr6NMYhvnobcy4y/TvgiadnEbRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(2906002)(83380400001)(2616005)(86362001)(31696002)(36756003)(82960400001)(38100700002)(316002)(4326008)(66476007)(66946007)(66556008)(26005)(6506007)(53546011)(41300700001)(186003)(478600001)(110136005)(31686004)(6666004)(6512007)(6486002)(966005)(54906003)(5930299015)(8936002)(8676002)(7416002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05MYngwUktISWIzZFlHM1MyditOa0VkeFZaYnZjd3o4MVo3SjZ6MkYwRHNj?=
 =?utf-8?B?SDRZNnZOSmo3ekphMmw3d0N2dnNwOExzdkxCcWFnbkJnVlB0S1pVbWZnNTVL?=
 =?utf-8?B?enR1a3YwWUVVcjZOSGM2dmdrc2FueHUyeWhoaUtIME5aVXhFQzZ4ZUs3dXdu?=
 =?utf-8?B?c0NIeXo3cGc2QVdNSkpwbzhuMThacDBLeW1tUnRhU1J1eHBUQ0ZWU2Npdllk?=
 =?utf-8?B?aExBa0d1czdPYUx3RXhKK25sd0UxVTd4OXBwMlFCL2dLTHV5dE5LL1k2dGVq?=
 =?utf-8?B?U0JmdURxc2RCMThpKzF6dktNMjAwVTBhOGVMOGRPdGhyc3ZON3A5Vi96djJo?=
 =?utf-8?B?SVJCeDkwM0pPWGozRmVGTmpjTThlL0RFUGVhYy9TUUxXb1FTcjFNcE1vMW5y?=
 =?utf-8?B?M2dPZmU3R0RCWXhhOGRkOUFrc1pvM2lmZVFRL0tyUHd3OHBYYkpuVkl0cmU4?=
 =?utf-8?B?aUZ5TDNoa1RObjliZU5wc2NIWjJIeW5IZnV3N25mTWlzL0g0a2dVM2FRZVRU?=
 =?utf-8?B?OUVJMGlQRGgzd0NyT1dZRG5sUnhzN2toVWpFelZ6SFppUzE3a3pGNDg0Q0pT?=
 =?utf-8?B?dW5yVVl5TXRVS3A3Zk9nYXpRS00vb2trK3NXR1FCeHFhQnJoaWZ1cFB3Ykhk?=
 =?utf-8?B?all6aDlkb1o4ZlBGOSt1MzJiZW82QzErclROL3d6dGJJSDBRci9DZk83V3Zh?=
 =?utf-8?B?dnh1cXA4K1Nzc2ZNUzVrdDZ1blNNV3lYZGxscS9Dd2QxS0tqeVlKMUFGUk4z?=
 =?utf-8?B?R0FpSFB2MGM2ZTR4djJKQStmRi9rbmZ5bFU4aVUvOEl1RDUwMm9uMmhqTTFC?=
 =?utf-8?B?ckorTGZTZHUxcUw1NGVkTzgwKzFkTlhaS1FPckV6ZUw0QmFtYkRReGlnRlpi?=
 =?utf-8?B?RlJad0dMQzhSckduNHVqbGl0aFR6TkxDaC96WkY1eHFLR1pYZDdkbEFHS1dx?=
 =?utf-8?B?UG9nd1ZyYlh0Y2Eza1ZjWndrYVQrQXVHbUVPK1BNUUg0a1grQkNJVXFVcW9F?=
 =?utf-8?B?YlpldDVKaGxla0tNeGNMT2JOQVZYSzZpMGV0N3Njd21QSUMxeXZENHFUeGxz?=
 =?utf-8?B?TlZKUkgrVlFpcitLbk11WDNmb0dkT1E2c1FJNlZ0OG5YejZxeWF3YTQzUm92?=
 =?utf-8?B?eUpXcUlaTmFBZmpFOW5NMkI0QkhJNy9oeWRWb095anRta1dxV1RMQTllVExa?=
 =?utf-8?B?OU1QOXJxVUlHTDJBSGFWU21FSGxFR2MxRXlqVUhPSFptS2FRTGZyTnIvTzBI?=
 =?utf-8?B?ME1uRDkySEwyRWE1cFJhajVYK0FaMjVBaWd6c3dvUU1kc1RwdEJWdEdtemNZ?=
 =?utf-8?B?TDZRbUc2aE9tRk00UUNONnZLUEwxcFkyUGd1S2Q4QWFQUFdJTm9ZSFVhdG9O?=
 =?utf-8?B?MmZETGJWaGliMDVGSm5HOE9wV21Ea1Z0YmVZdXVYbVF4WHZhRDJCNWlxVi9U?=
 =?utf-8?B?SE1DVVFha3dGRHZuR0xpSXJJbXVlRll4dlg1OGVFamc3WWQybHBHT0FIejF2?=
 =?utf-8?B?R0hFTE1RZkRhbEZIb245YS90ZndEeWpSeUUzUVhVYnhCY0JEUi84aEVvL0o5?=
 =?utf-8?B?ODRBK3dHRDNxTFRnV0twMEJvckJNSlJCMDZQQ1F2UGpDRWUyUGtzQ29wQm1E?=
 =?utf-8?B?RUNqNVlveDI4YTcyN2d4akY0ZVpMVGs5b1FGQjkwOXNjL1g0OWlXVFdlKzhH?=
 =?utf-8?B?N1JBUFR6Wlgwc3F4SHhCYW95UlhUbjhKNE5wZFYrODRueHl5cXlUTGxqSWZj?=
 =?utf-8?B?UG1MMHh2NU5WS1gvRXk2ZVV5UnNFWFlkYTVMRnJ5dzRjSUFueDZKYzRQOW5Z?=
 =?utf-8?B?dnlqZHByRlN3SDdjRWhBd3NyajhlY3Vwek9aLy9RQnMwa3NOL3BHcEVvZ0JG?=
 =?utf-8?B?TTV5VWh5Y1FVUXE2M0FqcXVoZXpuZStPNnpGSjBWbml3cFdLdWdaVm1BTkts?=
 =?utf-8?B?MDlaNTRvSCtsNy9ZeitNcHZqS2lvbkg2Q0lhbytIMjJWQWNFT2NPTHFpZVBl?=
 =?utf-8?B?ejFPOTRLRFZLZ0o2MFJvcm9xOUsvZzZWemtka21YNVkxU0crbHRSR3NtUnNB?=
 =?utf-8?B?Q3dKZ0pRR3RFazJIdnNMQ291UWpTU0xiN2tXL2xiRWRqV1V0TXU3WU8wZjNX?=
 =?utf-8?B?b0JGTHhweUw3WWtTUVZCSnErbi9OZUNYTVVrbm40ZnMxWE9uZ3pETEFjS29S?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bCtYdjcyQ1RnaXFFU0tBY1V5dkxycCtINWZUbjN2dDVkeVlIZmd0YlpLTjF3?=
 =?utf-8?B?NEhJdjc2REJ6NXpkVHg1TWEwdDZtaVQwd0J5UTIxemtCYXpmOUc0MHo4cnVD?=
 =?utf-8?B?OHFnSktETmdWSnFqdThJRWszTXYxK05hU0Q2QjRvaXVkMGxZMjF6MEJrMkh0?=
 =?utf-8?B?eVRtYkVWVUJWbTZpTThueldvTGhaZEwvQWtBaHBzdElSTmJZSU02cXFxWStS?=
 =?utf-8?B?eTBjRHp3aXh1T0trd2ZFRzA5dmFyY3E4Yi9oM2ROaGVEclQyYTRTUWl3Vitm?=
 =?utf-8?B?ZkwrcVc0dExDNkc1VUNiM0dyWGZDc2FGL0kxck44RkkrZWloMEhEM0I3SEtH?=
 =?utf-8?B?KzZCU1ZXcGZGWk9weGh3Y0VoREtLdE0vRnNPbVBtaGZZTzU1dWFidlBETWFV?=
 =?utf-8?B?OVdmOTNQTXRHNkRtTitOWDVZbW9nQTFaS0V4K0trZUFDR3E2ckVSL3R2Tm1j?=
 =?utf-8?B?MXRlVkZMV3V0MnlRN3p4aGcrOW5FZi90bHptWDJyN1l0YUZ1dmFUUkRFbTYv?=
 =?utf-8?B?K0ErNzZYdHMxbTFUVUVWamtRYm5sSi94ZEVxWkdHV0NaQjl0dTlPYnM2QmRn?=
 =?utf-8?B?eGlyS2tsU2p0VGZrbTVhSW9JUmJ1aW1GNjVPRklGZ0pTc2V6dEYydmhLNFpy?=
 =?utf-8?B?SW5VL3cxNkM4NkcxYjRzVG8yMzFDQWp3SXF6bXV0RXZGL1VTdDlOSWpyVU15?=
 =?utf-8?B?Y1lTQ0FnYWVDZ1NhWTVDbDhPQ1hINVU0TjcvbWpCdXJVaytPdHFqbkd4ZEs0?=
 =?utf-8?B?QVpKcXg1ZDN6WlgzdzhqZXhmc21HSG0wK08wUWU1M1Q4S2p5eXJldk1aZGM5?=
 =?utf-8?B?MUpobmlBWEk1ZDFra0VBbnRDQm1uWmhiNmQwVzN6bEphMUw3Yjl0WDYwOXRH?=
 =?utf-8?B?TlMzaE1idkNoRHd1QVJCdlhXcUEzdC9KYkZBQ3Nkc0J5Ukx3NXF3NkZybHlY?=
 =?utf-8?B?OVpwb2NEMnhDV29rUHlJejRhTjEwMDBIRjdZeG9OeWYxR3FLVkxMMUlWOElM?=
 =?utf-8?B?ekQrSUkyZUVFVlpqYm5VeGFodC9XWlFMQ3g0Qi91S2l1N0xVQ29UOU1pVG9C?=
 =?utf-8?B?dldzbzRoRllZV2NtWklsNHZ0cXFGb3RTQjdySnlnU2Znb1NaWjJ6NVliY1l5?=
 =?utf-8?B?VTEvdHJWVGJmanV2N3ZTV2FkZnA4YkJCNFF3dW5naW9RbGowT21JbVhudFZ4?=
 =?utf-8?B?VFdUclJpcWpWcHRybGRFREFLQlViQU51R3pDQVllNU14d3JKTXpscGF6Mysz?=
 =?utf-8?B?dHFPdXVqSjBRVy95TUtvQ0NtOVNURm5IWTFCUFpHaU40TlpqS0pWNlE4UDJn?=
 =?utf-8?Q?iYX2pBuMCoHmLlSHfdlvm9r6u+2d7OtRzE?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efc393d-b6d0-4a75-e7d9-08db890e9ae4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 10:46:42.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovueVh3ier7gGPYRkehRo1/hss1Vkyq7jzYz4bnaqgQCdtF5BhJhgZ5dpuZPPknaQXiXidKKdoiTtvbhv+DKCV+KCJSt1oP34Y6roL3YW1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6183
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/07/2023 9:03 am, Peter Zijlstra wrote:
> On Thu, Jul 20, 2023 at 07:26:04AM +0200, Pankaj Gupta wrote:
>>>> My understanding is that PL[0-2]_SSP are used only on transitions to the
>>>> corresponding privilege level from a *different* privilege level.  That means
>>>> KVM should be able to utilize the user_return_msr framework to load the host
>>>> values.  Though if Linux ever supports SSS, I'm guessing the core kernel will
>>>> have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit to
>>>> userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
>>>> per-task, on every context switch.
>>>>
>>>> But note my original wording: **If that's necessary**
>>>>
>>>> If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled in
>>>> IA32_S_CET, then running host stuff with guest values should be ok.  KVM only
>>>> needs to guarantee that it doesn't leak values between guests.  But that should
>>>> Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed to the
>>>> guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.
>>>>
>>>> And regardless of what the mechanism ends up managing SSP MSRs, it should only
>>>> ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e. will
>>>> never consume PL{1,2}_SSP.
>>> To clarify, Linux will only use SSS in FRED mode -- FRED removes CPL1,2.
>> Trying to understand more what prevents SSS to enable in pre FRED, Is
>> it better #CP exception
>> handling with other nested exceptions?
> SSS 

Careful with SSS for "supervisor shadow stacks".   Because there's a
brand new CET_SSS CPUID bit to cover the (mis)feature where shstk
supervisor tokens can be *prematurely busy*.

(11/10 masterful wordsmithing, because it does lull you into the
impression that this isn't WTF^2 levels of crazy)

> took the syscall gap and made it worse -- as in *way* worse.

More impressively, it created a sysenter gap where there wasn't one
previously.

> To top it off, the whole SSS busy bit thing is fundamentally
> incompatible with how we manage to survive nested exceptions in NMI
> context.

To be clear, this is supervisor shadow stack regular busy bits, not the
CET_SSS premature busy problem.

>
> Basically, the whole x86 exception / stack switching logic was already
> borderline impossible (consider taking an MCE in the early NMI path
> where we set up, but have not finished, the re-entrancy stuff), and
> pushed it over the edge and set it on fire.
>
> And NMI isn't the only problem, the various new virt exceptions #VC and
> #HV are on their own already near impossible, adding SSS again pushes
> the whole thing into clear insanity.
>
> There's a good exposition of the whole trainwreck by Andrew here:
>
>   https://www.youtube.com/watch?v=qcORS8CN0ow
>
> (that is, sorry for the youtube link, but Google is failing me in
> finding the actual Google Doc that talk is based on, or even the slide
> deck :/)

https://docs.google.com/presentation/d/10vWC02kpy4QneI43qsT3worfF_e3sbAE3Ifr61Sq3dY/edit?usp=sharing
is the slide deck.

I'm very glad I put a "only accurate as of $PRESENTATION_DATE"
disclaimer on slide 14.  It makes the whole presentation still
technically correct.

FRED is now at draft 5, and importantly shstk tokens have been removed. 
They've been replaced with alternative MSR-based mechanism, mostly for
performance reasons but a consequence is that the prematurely busy bug
can't happen.

~Andrew
