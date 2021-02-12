Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4B2319D0C
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 12:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhBLLF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 06:05:26 -0500
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:8668
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230394AbhBLLDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 06:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulmpvo6mp+m2j2y3jOyxoGfBIAnXzPgon/L9N9EgQ6o=;
 b=HTAfmC/jvPlZ10NSOyMsEUvvy9PoFuJ/RvpCjUkEXdvIcgzWESQgOlbZkuIEmPC6V2sD+xuMEpcuJKpKS6ZYOLMDfhaNtdbOwJOfKWtnrOl3dhbeHz8IhUr5t4RxAwpuPEl5imYH+SHiFnu5B76wCTT9Qi2LV7UN/ZHOsbiE2Bs=
Received: from MR2P264CA0069.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::33)
 by VI1PR08MB3551.eurprd08.prod.outlook.com (2603:10a6:803:79::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28; Fri, 12 Feb
 2021 11:01:58 +0000
Received: from VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::56) by MR2P264CA0069.outlook.office365.com
 (2603:10a6:500:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27 via Frontend
 Transport; Fri, 12 Feb 2021 11:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT010.mail.protection.outlook.com (10.152.18.113) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 11:01:58 +0000
Received: ("Tessian outbound 4d8113405d55:v71"); Fri, 12 Feb 2021 11:01:57 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d8e85971c8850f1c
X-CR-MTA-TID: 64aa7808
Received: from 16b8258593cb.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2A316B65-6831-4FE0-9917-2B22B28962E3.1;
        Fri, 12 Feb 2021 11:01:50 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 16b8258593cb.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 12 Feb 2021 11:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UW6g7L42NLnPJlSMFa/Q9+KRCDfzrj0V5tcIdpF46WDc2uYbGdYIfo9cffPS7SCln8fcnhMSCSxZ3psq8l+sOsH5HgP3imf2t+idejFU9Gy2STrOQC7PDSBzVjsv+9R+LImfar7LbAm0DcLEsZBJrmzMVdFwYN39NLUtSeknjI6hLX7DNpIW/gII89h8KdrgkbdruRTepY6mkfh9DJDAf72X54AO3ToxnBDFh0A32L1IR5gu7K0btbv1J9BlRCdrTZqQlX/+ATfOu/Hs+miL56T3AywuBv0moeMOAo2IA5xn5GavLbD3Tp0Jgwo5mLwRftTO3siklp2DANK34iiiOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulmpvo6mp+m2j2y3jOyxoGfBIAnXzPgon/L9N9EgQ6o=;
 b=naWYCV9J0uZvXE1P5KWlPD1lFWy9B4wPibWuSWLFqL2YLpl3z37uvQDMwtzNmhx9Mzbm7AV8MOsnOic1ljJclLiPC6OESt7Ynkv9h318sSk4n+Pg5s97rdHZQvTdQ95UXMH7WHRtaq48A0CrYzclP0KKmIuqs4CymeN+Lb+BnVqlC15onkxW5ezY+kxwU9Rgpa3O8spf7jjRNiLCcFFuX6ICchpjMy68LMvFbOD/ixVFZpmtbtMzoRqEupN8UNj6u0GGJfUt9Pf9oRZSbuWg7Mdw5Ipm9hFxyVgWy1AaOYwszaJfilez2rNt2XWyWAbT89tOIIXiwynDrp2WkDrtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulmpvo6mp+m2j2y3jOyxoGfBIAnXzPgon/L9N9EgQ6o=;
 b=HTAfmC/jvPlZ10NSOyMsEUvvy9PoFuJ/RvpCjUkEXdvIcgzWESQgOlbZkuIEmPC6V2sD+xuMEpcuJKpKS6ZYOLMDfhaNtdbOwJOfKWtnrOl3dhbeHz8IhUr5t4RxAwpuPEl5imYH+SHiFnu5B76wCTT9Qi2LV7UN/ZHOsbiE2Bs=
Authentication-Results-Original: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB3268.eurprd08.prod.outlook.com (2603:10a6:208:65::26)
 by AM4PR08MB2785.eurprd08.prod.outlook.com (2603:10a6:205:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 12 Feb
 2021 11:01:48 +0000
Received: from AM0PR08MB3268.eurprd08.prod.outlook.com
 ([fe80::b55a:5a00:982b:a685]) by AM0PR08MB3268.eurprd08.prod.outlook.com
 ([fe80::b55a:5a00:982b:a685%6]) with mapi id 15.20.3846.028; Fri, 12 Feb 2021
 11:01:48 +0000
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, "Wu, Hao" <hao.wu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
 <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6bcd5229-9cd3-a78c-ccb2-be92f2add373@redhat.com>
 <DM5PR11MB143531EA8BD997A18F0A7671C3BF9@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
 <9b6d409b-266b-230a-800a-24b8e6b5cd09@redhat.com>
 <306e7dd2-9eb2-0ca3-6a93-7c9aa0821ce9@arm.com>
Message-ID: <0f159062-98a3-ba9c-e40b-732520a1d1eb@arm.com>
Date:   Fri, 12 Feb 2021 16:31:40 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <306e7dd2-9eb2-0ca3-6a93-7c9aa0821ce9@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [217.140.105.56]
X-ClientProxiedBy: BM1PR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:18::29) To AM0PR08MB3268.eurprd08.prod.outlook.com
 (2603:10a6:208:65::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by BM1PR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:18::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 11:01:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 51b7740d-b203-455f-bbf1-08d8cf459e02
X-MS-TrafficTypeDiagnostic: AM4PR08MB2785:|VI1PR08MB3551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB3551989AC21745F72F4025F9898B9@VI1PR08MB3551.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: AJbR/j61eptCL4+FiyeCKqfoydP0AvDR1bjKaeTI3uKGa5D/VinOz7+0YXZ/IPUqvH7s3gi6/lgMOXQi0z0jB9+Ftrb06cjdGKVWmcN7MoiOf2+ICWchXJ2b7kkNMZ4/ksfviwFgEpRwY4Yidnr1Nm2N0VzQgVdSKg9Ozye0mEScvXKBEp64+w/106Z1xyrxOLMi6wI5TiBQpgF0wHlQMpvL//pCAYEEcj9Ni7cWh5JPkFaN9u53s4OGBqPtKGYsdDdkJIl3S8o7Gb+tHqaK8NqVo1h/z4BKE4CtBXLVlwEyMiPU5FUEFhlR3CG2PlP4QH0sCRnQ8+DdFN+gh9a9DoWMLeC9syClmCbxftMGysPmteSYt0GtYbSUEsi8rvzNKDcm7hEOPFKI5v+/bpA2M0MPBQEjvpUzprZyogmeq5QK+lSa7WbEFR0WY26e0lKmfvsuQTwiaEkirjiwaXcaV4TWuvdo9Oqt2A8EVIflvd5urNqpA8rJQO+43hW4pMyNcBiRBnIVMW/osEVraOIvuXpUgRja/TYduqcGks9qzZ1Ji6tFOixCXQy+qM5ysIIJsj/czVrT4IPSjrq5idSY3ndPTD7KKRuvuk6YQVAWmJ2887epxhHpsQx+3HQujJH9sc2IHWTQxAimEH4M9z1YyqvC2PN8Fw3k42v3uG6t/MxVyPtS6UrQZUgGt9Jn4bGF
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB3268.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39840400004)(36756003)(6486002)(31696002)(31686004)(186003)(16526019)(26005)(6666004)(966005)(86362001)(478600001)(52116002)(7416002)(316002)(66946007)(54906003)(83380400001)(2906002)(110136005)(956004)(2616005)(66556008)(4326008)(66476007)(53546011)(8936002)(8676002)(16576012)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NEhKdG4xWHNha2Z5SUkrbFp2eWxXclgvYldxR21uQVFiTFRHWTNBb3FyQmp1?=
 =?utf-8?B?T1BxL3lkT0ZNWjVTNHMrd09VZ2dPZVlTS0NuQlNJVVdpek1lSkltcnZSc0xD?=
 =?utf-8?B?YUtkNno5bUhNUU9vWWRqbHJIWm9rd1dYZVhwS1BWK0xVTDEvT01CcEt2TVJh?=
 =?utf-8?B?RWgvdmV4VGkvbTVoQ2I1WHRDVy9tTzBVZENTOVl0UGJNWnFBM2lJSmk2ZU51?=
 =?utf-8?B?a0M1M1hKekxseG83UXNJaWhiNmJKNS91UFh2aUNxUkxTcDlZUC9wd25kTE16?=
 =?utf-8?B?cWxraWtqdkkyRmpKbzlGaitUajg4Q28rMjMybWd5ckg2R2dSSENMek83RGZr?=
 =?utf-8?B?SzVaRnFFR1NYNWNoNTZqTkp2WGRrZlRQZVdEVjQ5RGxWRU55YXNwTGppVnZt?=
 =?utf-8?B?L2lGMm56Z1ZWNUlaRFFKanJDRmxZRmxPT3luR29JcGpMbzZybm9VSm1YcThv?=
 =?utf-8?B?V0tPNGlPaDZrS3Z0Y1ZaSFJ4MzJlUmFZNUwwcEtjVE1pT3hDQU5hcjYrUm1y?=
 =?utf-8?B?OWNHYmtUSFhYTWpxVzhvT0tSVk91dXdyS0kzUGdpV0VPeE5tQjV6THg2bzZm?=
 =?utf-8?B?M1NIRCtGWDJPOTJUeHA3cTZKdXlFMEVSZlJ0Vko3aHozclFCbzBINFlWczNV?=
 =?utf-8?B?WWRQeHJUR1hqSjhpb3kyMWNYMFpDZ0dSdnhGMERBdkZ4M2luRzJhR0Q3WURB?=
 =?utf-8?B?YUFxN1kxVGVHQkpFbDhiYUpBcnFkMDVjT0hNajhzSzAzbnNJUHowUnE1UUFN?=
 =?utf-8?B?VFFCcmxYMWFqTFBQTzB4TGZzZ1NnNUplM2l5M2Z0eVY2TkZpdy9TTUdPUnNF?=
 =?utf-8?B?THVnZ2tmTFV3elZqSDF0c2xQT3k1R3ByQmdKa1RoNFdSMGxMSUp0OEVXUWly?=
 =?utf-8?B?QzVlc3Y3bWI1WlIrTkJYdFZuMVIrNFprVjJ4d3NBb0MzWmFIYVpmZmgzaVEv?=
 =?utf-8?B?ZG1VdlZXY25uVnRPQnpROCthcTh1RHZ5L205dnhMM09SLzNxSjhnbCtFcUd5?=
 =?utf-8?B?TU5MWGhQRllCdGtwazc4RmJGY0tSd2E2dUxXMXZGV2xSaXU2Y0JXWE5VbTVw?=
 =?utf-8?B?UGVlWXN4T1NsQ3FxU1Fmdm45Y0ZTZndHMW9xMmJoUEZkWWd6UWlpZVBVbk9N?=
 =?utf-8?B?bEJxQTJselMxOWxhVGJVTWVWdjdmZ2V3Zk9qOUF5akJvRDFpTlR1NmI1cWsy?=
 =?utf-8?B?NVl6K2dkREZEcmF5L1dBQnhDVEtSbWxZdWZvZlNzYVhEL1ViUmJueWp2ZkRi?=
 =?utf-8?B?K3lDTWU2bnZyOCs3cFVjSWdBQWJZeFNKOHJLVkNqdytoMEJ2Mk44UmlvQU5L?=
 =?utf-8?B?VWkwcjhYemlHTHlrdXZlTXdRR0hWM3VveUNoeWl5U0VoaHdKTU9VSEl4OEFW?=
 =?utf-8?B?S2NrZkpYSWNGU2FjUWZVeU9wN1B5MU5PeEhLK1N6ck5lWFRVbHNocjFaTFp0?=
 =?utf-8?B?Z29HUUorTnVZZi84VE15b3BjVEl5b1pRUW12MXl0aWovL0xsYzl6bUZFNlJ6?=
 =?utf-8?B?UmxOQmdJaTFURkZ2Z2tqQ0FMZW5VYm5qY09wTHhCenBXWi9FdU80Y2pXeVJt?=
 =?utf-8?B?MWIxS1l0NFFqc3dsU3VvRUc1bkdHUDdGckFvSnJtRStTSmc2MEtra0pUWjJQ?=
 =?utf-8?B?L0hTS1VrbUZ5V2l1WEdKZTdWTEE0R093T0JFY29RanNxR01vL1ZjUHUrZVFZ?=
 =?utf-8?B?Nk0ySmhEU1lrNTcwVjc2ZWhHMEhpTDRHaWFWV0ZXaVc3bTkwMlBoYTgwOFM5?=
 =?utf-8?Q?ucPztYoF56MpBmB36iPFBfVvaXnvhg1Psf8hI/3?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR08MB2785
Original-Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 07e83b6e-e521-4e13-1013-08d8cf4597dd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6e7cPTrxlySPWTAjugqj8S41KsKGzZrTDyopi9wZgKTesM26QeNNbD9MkyJZ9oLrwA3AB5LBpz4xG0xwGfGXrQ6jxRfVhaM07HvnRIXLskU/L0E4QI1qxhhJBsE6QdMhZ0zaMjlJsw2v05ACAqWB7EEKeJALCIfXYjzxdNUhR7hQl1WcFs/kiXxldHKC6vaF1/esz4tOs0guUIAHjWaQ2/gVQZ/QJKHo9jWVE2QxAQQMVBS8WS67UvKfAVeq15xkaenxBlsS747sp5yLn2FfnuOPMbCQfzIndISh3hydBZhG6iK/HyUc90oFZCQ1yG+hyD3RemnyJHpGW3k6d9zt8aVE8eEjJ9AAEsNnfop/qYsw941IzBugYG2Pm7FTGV54Nrn0rTeMxCQ0WqoQYu7cZpMoLQ8gK3PB4DRG2OE/FZ8eptJoH0A/O5jiMd+cXjJnqZColaMDYDU56b0Kyy9C/r30gWauDp9yEx4TWoazgzSSPA6M1/IcTgOc/WC88uNhpRJD4N/DBOUOfEGmhPA3A3d9WVrsVNBKrJcbRmseUbXxGqVzsIOkKsFqIGTkKhnS98POksTUToMvYwlrHY79VfrEcQyO6vnpDcmjr/RCLTkTcV5EoxpdeRmxww6mD+XRBGe5juOYQeOViy2kFlphhYNW7xctt2jSHgLFoWggs87dntBOge+X/dRhCBQavG81XaC1U4XZKdC0DiNpHTQbYlwidtIXnXGmleOC2kqD4q3BtpPyqn0SHpVfaWSYdFImhLOFhOKJCfxpKXdabcO8cw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39840400004)(136003)(376002)(46966006)(36840700001)(36860700001)(54906003)(16526019)(83380400001)(81166007)(16576012)(356005)(2906002)(47076005)(36756003)(70586007)(53546011)(110136005)(316002)(70206006)(5660300002)(336012)(478600001)(31686004)(107886003)(2616005)(26005)(956004)(186003)(8936002)(6486002)(8676002)(82310400003)(6666004)(966005)(31696002)(86362001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 11:01:58.2318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b7740d-b203-455f-bbf1-08d8cf459e02
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3551
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,


On 2/12/21 3:48 PM, Vivek Kumar Gautam wrote:
> Hi Eric,
>
>
> On 2/12/21 3:27 PM, Auger Eric wrote:
>> Hi Vivek, Yi,
>>
>> On 2/12/21 8:14 AM, Vivek Gautam wrote:
>>> Hi Yi,
>>>
>>>
>>> On Sat, Jan 23, 2021 at 2:29 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>>>>
>>>> Hi Eric,
>>>>
>>>>> From: Auger Eric <eric.auger@redhat.com>
>>>>> Sent: Tuesday, January 19, 2021 6:03 PM
>>>>>
>>>>> Hi Yi, Vivek,
>>>>>
>>>> [...]
>>>>>> I see. I think there needs a change in the code there. Should also
>>>>>> expect
>>>>>> a nesting_info returned instead of an int anymore. @Eric, how
>>>>>> about your
>>>>>> opinion?
>>>>>>
>>>>>>      domain =3D iommu_get_domain_for_dev(&vdev->pdev->dev);
>>>>>>      ret =3D iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING,
>>>>> &info);
>>>>>>      if (ret || !(info.features & IOMMU_NESTING_FEAT_PAGE_RESP)) {
>>>>>>              /*
>>>>>>               * No need go futher as no page request service support=
.
>>>>>>               */
>>>>>>              return 0;
>>>>>>      }
>>>>> Sure I think it is "just" a matter of synchro between the 2 series.
>>>>> Yi,
>>>>
>>>> exactly.
>>>>
>>>>> do you have plans to respin part of
>>>>> [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing to VM=
s
>>>>> or would you allow me to embed this patch in my series.
>>>>
>>>> My v7 hasn=E2=80=99t touch the prq change yet. So I think it's better =
for
>>>> you to
>>>> embed it to  your series. ^_^>>
>>>
>>> Can you please let me know if you have an updated series of these
>>> patches? It will help me to work with virtio-iommu/arm side changes.
>>
>> As per the previous discussion, I plan to take those 2 patches in my
>> SMMUv3 nested stage series:
>>
>> [PATCH v7 01/16] iommu: Report domain nesting info
>> [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
>>
>> we need to upgrade both since we do not want to report an empty nesting
>> info anymore, for arm.
>
> Absolutely. Let me send the couple of patches that I have been using,
> that add arm configuration.

Posted the couple of patches that I have been using -

https://lore.kernel.org/linux-iommu/20210212105859.8445-1-vivek.gautam@arm.=
com/T/#t


Thanks & regards
Vivek

>
> Best regards
> Vivek
>
>>
>> Thanks
>>
>> Eric
>>>
>>> Thanks & regards
>>> Vivek
>>>
>>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
