Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206016A1AF6
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 12:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjBXLBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 06:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBXLAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 06:00:24 -0500
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A461B63576;
        Fri, 24 Feb 2023 03:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1677236405;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q4pRj+lApAO29UsmHk3xOQLyT7j5LdoqZnB+rheaQl0=;
  b=J3rSZQEXOkfdQyAGiPCs+JtG6MyXccqynhV+1rxpo6Rko1FWoAZPzDNu
   defXE6lhrm9YbhuYOlL+UxlBKaDkTQOFJeB5uB40nHzohOchVVFFUNQrP
   hNaZOKCvT/iDkTDFRCLnO/iMGwP0KhtXjKsh8spFu3BOxjx+Ac2LkkRJK
   0=;
X-IronPort-RemoteIP: 104.47.59.172
X-IronPort-MID: 100819730
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:T3ke469c+70+vO4LqpR7DrUD8n6TJUtcMsCJ2f8bNWPcYEJGY0x3m
 mAXWWHXb/6NNGXxKtkiO4+w9EICvJXXx4QwQAplqn08E34SpcT7XtnIdU2Y0wF+jCHgZBk+s
 5hBMImowOQcFCK0SsKFa+C5xZVE/fjUAOG6UKicYXoZqTZMEE8JkQhkl/MynrlmiN24BxLlk
 d7pqojUNUTNNwRcawr40Ire7kIw1BjOkGlA5AdmP6oX5AW2e0Q9V/rzG4ngdxMUfaEMdgKKb
 76r5K20+Grf4yAsBruN+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+v9T2M4nQVVWk120c+VZk
 72hg3ASpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn9IBDJyCAWlvVbD09NqbDklc1
 8M4KyIXViupirO90puiGudvp8caeZyD0IM34hmMzBn/JNN/G9XvZvuP4tVVmjAtmspJAPDSI
 dIDbiZiZwjBZBsJPUoLDJU5n6GjgXyXnz9w8QrJ4/ZopTWCilUuitABM/KMEjCObexTklyVu
 STt+GPhDwtBHNee1SCE4jSngeqncSbTAdpKROTpqaUy6LGV7jZKWERRBV6Vmse4sG+8W/d2O
 kIP8RN7+MDe82TuFLERRSaQsH+C5VgYWvJRFfE37EeGza+8ywKYAHUUCz1MctorsOcoSjEwk
 FyEhdXkAXpoqrL9YWLNqJ+XoCm0NCxTKnUNDQcHUw4t/dbuuscwgwjJQ9IlF7S65vXpFjXg6
 zSLqjUinbIVjN5N26jT1VXGhT2rjoLEQg48+kPcWWfNxglhTIehZoGuuR7X4J5oII+HQx+Bt
 X4fls626OEIEIHLlSqRTeFLF7asj96FKDT0k09zGINn/DOok1a7cJxd+iNWJUFnKM8IdDblJ
 kjJtmt5/5JaOnmhRaBwZI21BoIhyq2IPczvUfbGb9xPSoJ8eA+O4GdlYkv493rkjklqj+ckO
 Z6dcs+2JXccFaljijGxQo8gPaQDwyk/wSbfQM79xhH+i76GPifKE/ECLUeEaf0/4OWcugLJ/
 t1DNsyMjRJCTOn5ZSqR+okWRbwXEUUG6VnNg5Q/Xoa+zsBOQgnN19e5LWsdRrFY
IronPort-HdrOrdr: A9a23:hL2/8K3RVYR3i0ZvNu88nwqjBHYkLtp133Aq2lEZdPU0SKGlfq
 GV7ZEmPHrP4gr5N0tOpTntAse9qBDnhPxICOsqXYtKNTOO0AeVxelZhrcKqAeQeBEWmNQ96U
 9hGZIOcuEZDzJB/LvHCN/TKadd/DGFmprY+ts31x1WPGVXgzkL1XYANu6ceHcGIzVuNN4CO7
 e3wNFInDakcWR/VLXBOpFUN9KzweEijfjdEGc7OyI=
X-IronPort-AV: E=Sophos;i="5.97,324,1669093200"; 
   d="scan'208";a="100819730"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Feb 2023 06:00:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZSQCHr+hia5NGQkYsZZMoU5kHTFHlP+cG8OKe/xBNj4/aC+ZwSoRYLU6I0Ho1ZM2m44wiG+RHR+dNPLOlhleXhJofwgo5DFN4SDgiOwfb7Y9qzw56CJm6AzhaBY28qWXZ7WZO0z3Gl9fKzKqLMneqp2P7j9MKDVHnb0c1kvGS2Lr9KdOdI1cgfns51LXfYrVQFQGY19p6klg0rVGox1b7EH6ytM+/dH3LBprpAe2lG10wHG26h6402K7mpnnbnvJxWjCzV1e8HFOmZ3Bw7tVNOYZ8orV40+B1OPPFN5StWDFoHW4LpRAq5anoYsVqeL0WXaFYMKvvQeIx+EyIcBkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frs6YygcITvsoWVq1GwH33Jml/Wk6QLtwz3eY3qlCIM=;
 b=aw5hUUa4I8hiakI0pO6LOhXM5/ESnK8CbYYiUNWQiNnXDeF4WLg5grba8aO1A1TkC+nvAMGjScuUPpq0cLUxta5lkf4skBk2ZZ7W/rwHNp7QeChjBPWiEWzeywi52qxiOpUuR9tp2d2NIHzZ/zdMCyW78QkfhP0aGvTYyc1ra0r+RGE5tMln1trrHkB9xI/GHPAyecG4fO85oPTsKlLEkoOHRGdkLl4XPyszXdVVIVcjHekEMl5g/1TMonoTp2JSec6iTpdeFQ9JMvLZKvI4yvQj7PeBmwYRFFVe89dHvwc4c7RCFjN5Q0kAbq3j61w5ihg65GddxJ3DEVUWUN92QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frs6YygcITvsoWVq1GwH33Jml/Wk6QLtwz3eY3qlCIM=;
 b=mYzEUGMdpyIx4ybDDu1XyTyhPkyeahf8L+wdu/sgMRRUSbkB0tkWHYAq1DdiiWTQsTzjl83UiRlLQFTHoQGWMFjtMx9+/KfqKlIAQCU4FN21+b9QYlMtl0/5HkWzk/ZEGcvxM593fWS9fsHVaAvYvlwKhtxJNRHZGb4avqim7MI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by PH0PR03MB6637.namprd03.prod.outlook.com (2603:10b6:510:b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 24 Feb
 2023 11:00:01 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8%7]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 11:00:01 +0000
Message-ID: <bf1ad4c3-73eb-0f8f-e627-a7e0785fe903@citrix.com>
Date:   Fri, 24 Feb 2023 10:59:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   andrew.cooper3@citrix.com
Subject: Re: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss
 fields in struct pt_regs
Content-Language: en-GB
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
References: <20230224070145.3572-1-xin3.li@intel.com>
 <20230224070145.3572-16-xin3.li@intel.com>
In-Reply-To: <20230224070145.3572-16-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::22) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|PH0PR03MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: 925703cc-95f2-482f-f60d-08db165646ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kr8CDS7ir67KbxT3n39anAxDvPputJ2C6MZjvOizc0MF3AvSOj/mGCpa3hkbeama6vkBRiLz+kYwn5gK47hzrauCha14Vgu7ntmUtzeVJNhWPqcmSvappwATkzd8tZvtAaxFb0M0etPFxra9yAdmGPIirsN9mXdch2j+of/VqOb8H2CpSGz2P5GilFo4P/+pF3/C/srE2WzGSNaWqj4Fo3mQZFS0elPvlcDFVk+OFnfd+wP8S2S4yhasrcz81pnzS/XdAiSmwEJ3rlzzSjXjsygwmfjShY95PMrOU9yhpzo663SU4MOsUwhcZ8jK/1XQsjvukox9Q8Z6KuO5q9Iw9RUKeCxq/pyX5uE1Uz5GiLHTkwUnByn/WEnhwbk6Oz8cleXBXrSIvWfXZtqo+bB/jVXy8Fzuom3fyA4rSVKzHt8y1/OUtKH8plrDYKnCYMIteNUZafGmsBqROScpL9lXCHrx56NTjFxkgbKX0bkFY23Tonvg8hbP7+i5mN38WQU8sMaLkNt0GpzoEJ2hhG7LlWNkL+Us4BycA7AoLFN0hCB3wmxCE17z5Or1CKSaTKOhj2FmztstsizYd2Ua4D9ztNoMxLTshLfeRy3b0cSdjvifxJ9VVDjG6UJ9aaPE5d4bpodd9OtkOMGT1n0l0j79UoCsRgTGRACGxwwjcPw7L4Fdo6ImkSvFRDMK1KfBpU1WQiVcqwMZ441puCQVLnCu+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199018)(41300700001)(31686004)(2616005)(82960400001)(2906002)(6506007)(36756003)(66476007)(66556008)(478600001)(86362001)(38100700002)(316002)(4744005)(9686003)(6512007)(26005)(6666004)(8676002)(6486002)(4326008)(66946007)(53546011)(5660300002)(8936002)(7416002)(31696002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnBFTWhORGtEMjhDUm45RDFvUGxqK3ZXdy9GYy9hdG45NUhVNU1RZDZvQXhE?=
 =?utf-8?B?M0ZtMzFqbWdGdVNiYVg4NXpXV1N1SzVmY3ZKSmVITjg1TFplclVFbVJwZjd4?=
 =?utf-8?B?MUU1d1hqN2xESnJ5UzkxR0JBbWVuc1BUYi9BN0pjSHFIUmwzb044dnd5Mktm?=
 =?utf-8?B?QXI3ZXBnMkpxVHJPRlY0c3hKdStvNDZTcXlBcUdzVWxNZThHWmthSjdsL1Ex?=
 =?utf-8?B?bWZBL2JOQU5YekFhUzcwWWRtc0o1MUNJcXFWYmNxOGtLb05PMUpOVlNoMy9E?=
 =?utf-8?B?OGt0NmV3c055dEJ5My9CSXluWWYrRExZUTE3VnI2TVFLQ3g2SXNwNzkzVUxz?=
 =?utf-8?B?RU56TWJkaWFObmc1ZUNIT3FKMW8zSHhHYndQcGdJZDNFa01zd2dXd0dwTmUz?=
 =?utf-8?B?cXFsRUpmdlpnOERWYlI4cGJaZHJWTkpxTXd0dXR5ZVBiT2ZUZEtROU0rNW5T?=
 =?utf-8?B?bnNOa0hoSnZjY0VVb1MvYkJSbXBzcVJBc0RsL0ZBQ2Q2dXpENWNxUllPVVVL?=
 =?utf-8?B?MUd5MWs5S1FGSFBhckRIdUorNXV5NXhYRStIdzVUVytYZ1krQlRhNmxqUXpC?=
 =?utf-8?B?bklrLzR5dnNLYVd0bkZaMlJ0UjFUNDFyREpNZWpyTzhUaVArb1BVdVY1VVpD?=
 =?utf-8?B?dGJ1Y1NtUysrcEFmRmRKSjVCQ1RnUURmL0kvMEMyVGZ6a1cyNjFXbGMzUlQ1?=
 =?utf-8?B?VlhuVXQyaEgzL1p4MmlGMXZ3Q041UFZ0T1hjdEpSaG1jN1ppaVRoRDh6NUl0?=
 =?utf-8?B?aHFtbC9MT2tJSHJ6d1dsMVoxSW56Nm9tRTUwOGp0RndDeWlxaFJNM2N4Sy96?=
 =?utf-8?B?MjAxY0FxenhEYW5TNElyajZ4dU5qQ05GcjY5aC9PUUE1OTF0SElPQlRHakx2?=
 =?utf-8?B?NGdENi9iWW1hNldZNmRmaTV2bFJHU0cxeDYzZStVN01TVWcwWTcxbnlxekxC?=
 =?utf-8?B?dUgrTFNpY0p4b3grdW9xYTJjRE9NQTA5YmVseWYxL043ay85dnNuUm5WdUNI?=
 =?utf-8?B?MHFMVWZaTTNUY09VWmttU3pnQ05GSExoanUrZG9FZmFoeWtVNnBMS3lLYUtq?=
 =?utf-8?B?eHRKQ2VNZUJsdWhGbHZoNUkvaEw4Yk1ocnhIWHI4eEthZjMrekRDNG9rbFFq?=
 =?utf-8?B?alhBbkQwQ2wrMlgydTVyTm1sZnVRaDFXTGZlb1JtclJ3ZXJabGpySEwxTVY3?=
 =?utf-8?B?VXBXOFR2d2RCSEl1VFB5dDJETXBrSTZzWTVGOXhzRzFvdkxlc0gvQVJSVG8v?=
 =?utf-8?B?M3pmL09VdzlmVGpmT3VSKzhCMVdGS3kzb1IreU5VeHpFZFcxS012WDNZZHJu?=
 =?utf-8?B?bEJRRDZxQTRZMUwxOHNkRkY3QUlXOS9XTjBTYmdJNmIvdWxxVEZUd1hZS1ZY?=
 =?utf-8?B?azFlN3dRSmtQa3dVR3lDRW4rbndyb2hBVnlNL1pJaWswU1kxY21IaHdZdE5Y?=
 =?utf-8?B?SnQraUVUVXRmM1ZsNTcxb1V4Qzl1WDV0ek1zMkp1aXJ6U29tUjZpNzdONXpJ?=
 =?utf-8?B?TGhHT1dzZ0txN2NiVDRYWjlMN0R1ZHNWZGpGQzI4YkRraGlabXA2V24vTjJT?=
 =?utf-8?B?ZU5yeWVNOE9zd0dzbzc0V1NpdVBlRjZid0xodWw5SUM4Tk92SlNJeVcvVlVo?=
 =?utf-8?B?aHRkRXJlT1R1MHFydTJhVWxvbzVnRW85UkxNUmFQWXZmc2hkQUZPT2tkL3FE?=
 =?utf-8?B?MEJEQldzRWVkYW5EbmpFdFBkVDkranhIb3lYMFdlTXVHY083dGIvblFqTzdN?=
 =?utf-8?B?ZDNVNkNtdm9vWTNwUU5DMGZldTQyZmppZ2VqaElodVEzVUpveWpMQVRMYlVM?=
 =?utf-8?B?a28wTDRLNHo3RDRzQXNCblcwNlZRRVcydHduM1VuQTJRaUlkQ2xtMEJzZzM2?=
 =?utf-8?B?bWkwUWFGY2F0aUlIb3lieW03OWRJMHN1aTNQNmVCZ0hmY1lxeGtpb2k4SzNo?=
 =?utf-8?B?VjNzRlpzNngxN3EzMlZDUWg3MWNiMjdIeGQ2cHpBeUZHaDA0QzlrcU5kcGxi?=
 =?utf-8?B?Ym5aNWRTRE5yV1JzQTFjS0dBRDVrQmdpK2pMVVhMbUJqcDNBSTFTUGlwbnNF?=
 =?utf-8?B?MzZ0eGRRMFgyZDFYaFhpRmI2YXduTmFWZGJEMUl5M2hGL2JNbjBxV1ViSjlB?=
 =?utf-8?B?ZjM3dFY1UGp6eGtCTWNCMG0xQ2NCVjFVcEkxNTZoNklYcCtFNmlFWjdLczJK?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RkVETi9KUGdFYy9ERVV3Qis2dVVZSjM0MVdyb2R6emJkKzdNcC9zUDhvcm4z?=
 =?utf-8?B?SlJzNStzZjZQWDJZQkRoNFhNMit6RFh6a1liQWdidTRHVFBaZTNNVHRsOVNs?=
 =?utf-8?B?T2xCNjZMRm9mQWE1S1MzeG9iV1VZSHF5NnQ1UGZtSTVQcUN4aGpXNS85dFl1?=
 =?utf-8?B?RlA0b0FqQm1LMmR1NXhNZE5rM0lwK2FjWDdKV0crOGdoQjVNZERSdVB2cnVO?=
 =?utf-8?B?cGN5Mkk4ZVpVMVM4dTJwQ05ZVGZvV1YwcGM3enBzM25IeUdDU0M5WmFIdmdr?=
 =?utf-8?B?TlpzS2haVGlmVFBKOTRXbS95VURKSndKaUJpbmRZK0RFUEt5TWlRektqZE4w?=
 =?utf-8?B?Y3pXOFZ4YnJQdUZsZXRQODR3UTQ3OU1CckdDY09CNC9uMXpmTjdTU2ZHK0NG?=
 =?utf-8?B?bTJ6dWtpOXFKZHVBZ29UM0F4dktwQ1E1ZmZQU0xZS0Nyb2lmNS9FU2sxcVlD?=
 =?utf-8?B?RC9lOWEydmhaaDZyUTlvNnU4aUJvMkIvMG1ua3ZNdXB1dDl1VzhFQTJYaHFL?=
 =?utf-8?B?SjRmSnFoOUFoc1R1SXpJZXVCOXZjMEFuZDltVEZtRndVTGhLOFo1N3pWWE9F?=
 =?utf-8?B?Q2cxM1Ztc2d0eUpuTEhIZXNMSVAxc1NuWm5rYkp4Yk5MSUFRTjhOUHlPY3g4?=
 =?utf-8?B?N1BWcjJVL21KRjRCdFVyR0ZwOFk5THpNVmFDckVZdXpzUzZ0ekF6Q2ZXR2VP?=
 =?utf-8?B?R2V0RGIraStmN3pJK0JxMWVZUjV0NmhkYlQyWnk2VUVtczNGWTdZdEpsVDZ1?=
 =?utf-8?B?VHVJc25PVkpJMHZqVG03QzVtdWl6Z2pGdGlWbzdDaEZEYjhlTXBveFhBMWZD?=
 =?utf-8?B?NTNEOHdMTzNLVWxodWpnSnp4aG1CNVdJQjZqQ0taRzdhblBMQk83cUFWbmEz?=
 =?utf-8?B?VkRQM1lHOVkwTmJmaERHMlhDWCtzdWQrVm1JT0F0U24rdXFmaTBmY3hZVVRI?=
 =?utf-8?B?L3gvcE5ZVTlHa1pvN1M4VHY1dTdMcVBlM3lhcTFrWDExa1VOb2picTNsWkxB?=
 =?utf-8?B?d1RMV2xYeUw4eXhYeDZCQ09lSjVNWURPYlVhblpPTUpzNUlsUjRKbmVNcnc4?=
 =?utf-8?B?aE0yZU04dS9ha1A5c1FLL21kS0RTNU0zNUZzZVNZTXlrMWgzNTV6U3lCcUk4?=
 =?utf-8?B?eVgzT3ZCSllLYkphL21vWXhaTFhxUkorZFR0ZXV5cUN0OFZOM0srR2piNlpv?=
 =?utf-8?B?NnZUbmNVMTJJL1lYME45TG1RTDB4cTF4WDdLc2NzS2wyMldrM3FnZTNuNEJh?=
 =?utf-8?B?TFpFSzVJcUtWZEV1eEJGQVNRcml5MXBIMlRwYnlHbTRlbnlNUGpCNjFBZVZ2?=
 =?utf-8?B?NGZKbER4NktXZG1ZMWRnUVgwVzZWeGRva0NFVlFzYU9ycW1xMmhJMTVDQkR6?=
 =?utf-8?Q?Cx3acowwKiEyZhnK857fpOUc+mbsvlPA=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925703cc-95f2-482f-f60d-08db165646ab
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 11:00:01.4386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqixzw7wa3aLCrMJO0Cb5HjKM3x76WkyEEZuuV+GjcnxmJ4FH/L5fCfxLop4J//yRhYCPK8EYlGTXcTrkOxSKwNE7H8nvPGdc9PG8+UA4Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6637
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/2023 7:01 am, Xin Li wrote:
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index f4db78b09c8f..341e44847cc1 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -82,13 +82,41 @@ struct pt_regs {
>   * On hw interrupt, it's IRQ number:
>   */
>  	unsigned long orig_ax;
> -/* Return frame for iretq */
> +
> +	/* Return frame for iretq/eretu/erets */
>  	unsigned long ip;
> -	unsigned long cs;
> +	union {
> +		unsigned long  csl; /* CS + any fields above it */

I guess that CSL here is supposed to mean cs long, but CSL (Current
Stack Level) is a new term in the FRED spec which isn't this.

This causes changes such as the final hunk in patch 27 to read
incorrectly, despite being technically correct.

cs_slot would be much clearer in code, but tbh, even cs_l would be
better than the version without an underscore.

And obviously, whatever is done here should be mirrored for ss.

~Andrew
