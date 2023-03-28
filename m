Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A26CBCBE
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 12:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjC1Knm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 06:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC1Knj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 06:43:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391026A40
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 03:43:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SAJXkE017554;
        Tue, 28 Mar 2023 10:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pBKRQahRuVLLdKXJx64+dl3FMMGuuhrvR6/eqmqKJfA=;
 b=DjyDSHMOwL4v2Pdmdf9TPxJkQDMoCRHgSx1Cwq0ZmlKhBI+NQ9pMFLYVwb77mU5RYCqM
 4+b46T/2zao9xVcoZVNOvdFqyE0elCJ5iExq8Q6khUXtab/yn7owlA61Hs45oLDGxEUi
 XlBupNzoh6oWT6rOxnWnS4uhv3JFHLCCDbV8CMgGrxe88N75+9UOiyS5urDK0Z6S3Jyz
 npP88C/dZSS1lLcTJd3Ot57IBRO7vkWFpTahc6Tz9TjuZDkNfHNlCHaJnC9TheXNu12/
 FffOkbe1cEA/9BqJY7flvRpwbMCGBmkzwHY+mveO+T621zOv6r0HUdRmYH+xekUwR0pj CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkxcpg2mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 10:43:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32S9wCKq027740;
        Tue, 28 Mar 2023 10:43:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd67cq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 10:43:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blx+SPUapnqHruddpLYxeRO53oAFgaUk7hqmPPfNOa3WiFuYkdlawPoxo7vYDp1Yw12xztSSVXD5XLebNkpN5Tq5X+6UuXTazA6nyXUQQGAQKa1HCrkLsaXiQiQAaQPhY06a3uAdvJhbqUff0gOPrY7zsC+TiCa1cEU3aEhcFi7Ynp3f3hkmp19u4G4vDS6xNROV++d7YzArfS1IrO6Efhkc3hc1gtSNl1NrlZLOPH44xIRlqyKQmMzNYHXJx1ude73bHofWm39BqUnpTLge9j1a8giqe7bEFApmwTKLS8uzatLBrVuOg9ddN1aIxq67DSwvRdHS/aWgMfesUm1N6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBKRQahRuVLLdKXJx64+dl3FMMGuuhrvR6/eqmqKJfA=;
 b=YqOUs6v9rLGCMp87lk3BWMpoW6OMrDUGLVg0ozEiDcdm91mkiCHr0KkeoUKqpcEqu5tKowuDDC7xfVKlrQyb+ENZAEevdLmfPfKnj/dV2FnG4H8kULB7W3OnHxxzvA4MGy/5uEW1dQVWdT4/o6zR0nd2HoY30X3nMTzK3yEDDHYWi4eU/xJpN1HAHS5CueLx9cTbXTFQgDQf5xc72+O3w8mySCsvRHU5QiJflmWLYLt4/Ske9Bf3P1Mhcre5Lyti/SPIH9mpnewf6C7PfkV36SDblKm4nxvb5ukXdWSl/JiWAUyTin/ygc7nqzEi1zqc5jC9mhTjUgXCI9iAJQR6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBKRQahRuVLLdKXJx64+dl3FMMGuuhrvR6/eqmqKJfA=;
 b=ovnGfq5jKUJ5VSnpqR0rlgI9HcGpxUzB7lk2SSR11bnwmNV0dT+n4sY6dYuvDmpK0fJtFVgZVqGsndWPPmNtp3tBJ6HD/yeRhvso6CbWk7f5/BokHYJ8V/ZDzCgmFOJs2sjhLQUquayhVt6ssuSoLrPzjTQiwQ1Cj9jjojhWTxM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB6684.namprd10.prod.outlook.com (2603:10b6:930:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 10:42:58 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd4:d27c:94b5:e2da]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd4:d27c:94b5:e2da%4]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 10:42:58 +0000
Message-ID: <cde77b1f-e612-2a9e-e437-8892f7f1fde9@oracle.com>
Date:   Tue, 28 Mar 2023 11:42:51 +0100
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com>
 <ZBODjjANx6pkq5iq@google.com>
 <655ac0f7-223b-9440-1bcb-e93af8915bfa@oracle.com>
 <ZB20W14VzVZZz+nI@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZB20W14VzVZZz+nI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0501CA0048.eurprd05.prod.outlook.com
 (2603:10a6:200:68::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB6684:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e49202b-63c4-46bc-d3d2-08db2f7931f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aw15mtb92MeLkdnj7ncNGq2+IE0ZTBibdRyIvORq3E4mvIaztbyl+7jypab+itxTdc6dX7+Pp1nknNoAa5XbwdNg/1qbrOgZpodEhBw1Y4TARXATDW/AER0f8N3t0mG7kSYigQoSrWx1NoRqzkrsqL+20GMzY+RGoE5SV/88qw7G339y819updtklvFS+TWp4hfX3CPRafJqVfQfeYXezryY+6koi4+vMCGQOAJpSYL7siu03fjx+eqsB8D0SUrQwhZV+FPp1K7IgndsmBJKzoTOZ17qFbGJ8A0+jbwG/EFUyhN2NjLvyYIViCdKZXxtOw+8ljGT+dbmJzrt2Xpl9nmnUtO/9p2+ooxbzwGgieC6ef4U31p33z5uaZJP4kPo2Pq5i//dOvJLcoRjdwBQ0o09kyBg6h8jHdoqdc9OKRtsv4D3d7fT9YsesNNJEDwGQG278T8JO5sJYU1soJjBOY8vBcF3YJlrx8wEFZ3JwhbOZZnvAbLNTiJPdUZjAe9d6mWIf3+5Y0DRY0lAaNwvIj/JSsCr4VBmA+5ryuHQimnZKJRdYVwugnamRqVOhdiIB1u6iY8eCIoJqW7O0ffsmEDfXp7IJMxPXrIVwCm1DRxTa9s/42B+o/1eWjll83s8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199021)(6666004)(478600001)(6506007)(6512007)(26005)(53546011)(6486002)(6916009)(316002)(31686004)(54906003)(186003)(66946007)(66476007)(66556008)(8676002)(2616005)(83380400001)(41300700001)(8936002)(4326008)(5660300002)(15650500001)(2906002)(38100700002)(86362001)(31696002)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlFFOTFMd0l0ZnpUYU12VGl2b2g2MmVQdzQ1YTRtT0ZLOGNJc0xnbkVtaSt5?=
 =?utf-8?B?WkM5dFlqbHEzbldiNFQ5NWtPa0xMclRlcGVoMHIyU2xYbVJadW51KzlFa1Nx?=
 =?utf-8?B?M0pXeGo3dFRmNkFZSzVhd2srYkVkR05idzI2ZnlXVHowbVpHNXFsdkVtQ1g5?=
 =?utf-8?B?cUZObUk2L1kzYWZhUlpxUHM3NE5YNE1hQnhPZ2ZVek1RejNTMnh5ZXQ1UWZR?=
 =?utf-8?B?VTFsSUJUMGtTeWNhOVYrb3FhODVjR2l5aUFvK3h1ZlovT2NEUXVGcXJXUllz?=
 =?utf-8?B?WGNETDNPRkFUdUtQeUl2N0lPb0g2ZkFhTysyQUFaZE9OL01VOFhMZzZqODRk?=
 =?utf-8?B?bGlqQVduMkxjSUNOelFIckVWNDUwNm8zTTBjbm5VUzM5V2FtNjJEeXVsdkZN?=
 =?utf-8?B?cTMyTlp0aUtoQkxkM0ttY01VdzlnNVZHc0tiT1pkNjNuOXA1R2lWSXErc3Na?=
 =?utf-8?B?Sk52TnJtVW1UVjZEd1B0ZTF2b0tRalFma2tmaHpYcjU2aEJLbmZ5a2sxdXA0?=
 =?utf-8?B?eTBGek42NU5QcWVBYXlHaWJYOVpBTmNYWTdmTklHN0FKUG5FWitqVTJ2NW5u?=
 =?utf-8?B?M1ZjbWNBZFd4bGNUOTQ5Ri96Um81RXh5UitoUThkeGFnaWdwNUFVbk4vQmla?=
 =?utf-8?B?VHZjZ0dYMGVsZ2VVTEhXazkrL0JUbW41elkxK3MvaWsyak5hM3JzMk1yQjE0?=
 =?utf-8?B?eU5JSk5ZUmZzbFlWMVRBZ0FiR0NKeGJrWGtuaHcwOTBtWkFLWXFZN3REWWhz?=
 =?utf-8?B?Ti9hd2xEdFZVQUs1bjlEUEg3NmJCb21hN2JUdTU0MUkxclpLYmlONkN4Si9v?=
 =?utf-8?B?enZLS1JodTFCWG9IVktJczNLWWRXVUtLTm42ZjQ0aG9WYzd6eVZVUWVMU2Y5?=
 =?utf-8?B?R0RqOTk0aHNvWDAxcllIYmdHVlpLR2VlbllJWUlZZGlRbTJmR0JsMDR1NkpF?=
 =?utf-8?B?UHMyd0ZXbENXbVp2YnhXYm5LVHo5Y0ZDVXlRRlMxaUZXRHA0Z1F0SEhRa1o4?=
 =?utf-8?B?aVNnZWRGZ3BzOGVicVRMNlZyaTdpWkJHV01KWVJBNUZ3cThTM0xYaEZsNUdY?=
 =?utf-8?B?enpka1RTTlM0MmQyNU0rRFVXZkVuT1R4MklPUnQ1TFY2OVZleThjN0ZVUytS?=
 =?utf-8?B?MmovTW9DTXQ2TFhFWmdkUGtYNjZpTFcxeVEzNTUvZUhKSXFneHFjZmtMYjNF?=
 =?utf-8?B?N2M3VkhNbVJTeXhWdmVBWFpRWEthbnFZbmZtZnZ5OXMvZWk3Qm9VMEFvYnRR?=
 =?utf-8?B?U1hGM0NqY3dKc1RkL2tNUk83Q2M3SmtGOGhHdzJDNzA4OXpPMW8rWktrWnk0?=
 =?utf-8?B?QkZ5REg3UEhzMFFHTTdXUExuTmFPbmRybHN5TkNqVlM3UXNtQkhMNWljK2F0?=
 =?utf-8?B?blRsZkZLaHFwQ0NVRjFuUzUzSGR2elVJRWZCczZtRnRvdHMxWkVrMmE4bUpy?=
 =?utf-8?B?eitXb0RRRW5ybURmdTY1bWJVdnJxeGQ2UFdRaWdOWmszQjM2TnFvNzlBRUdZ?=
 =?utf-8?B?Q205ait6RUdyL1dzeURJM2lUYm1zNjZwK2IweFdjMlpJUEtOMnFRVWNHNWty?=
 =?utf-8?B?QWtGaUUrcDJUK3pBQm1GVldHMHZlbDdPb0NpQ3FzSFQyNkNweXFRZ1lGVUo0?=
 =?utf-8?B?eDNmRG1MUDQ3NmFxd29WN2RmZVhKeXVlRE9RT1dPRXUrRXJiY0FJVnVkUGZk?=
 =?utf-8?B?SHNlSHplSjdSak1zOUNSOXd3djh0eEpHN2ZhNld3ZTA0MTIzTngvWEpCZFJv?=
 =?utf-8?B?SnFZd1MvR2R1NWdQTFVDc3pBbGlMSXNYaWtvc0hOK3VHcVNCZTJ2M1dLUGU0?=
 =?utf-8?B?a2dya3N0b2p3RTFxWi9JTVlFbHVpbEc5ZlR0YUZrOHh2ZTgyeUxBSFJLNE5M?=
 =?utf-8?B?d29lT01FVG50VlBXOTYzSHVjZ3RYcTBncDB2LzFJdk9UZkNyS2xNOVgxYTI5?=
 =?utf-8?B?bFdvN09HaUlnam1RZGsxMXBjeHJibFExM1lJRmt0SjdKWlMwYXpDckV0WWxH?=
 =?utf-8?B?eTljZGdRU0VpV1MxZEowSDczUmU4VVBHMFVGOHUraFA5bGtwbHJrTlkzVFA2?=
 =?utf-8?B?cFBObERFL05CMlY3dXI5a3FENnloV1h0MmVabUlPS1ZFMjdoeVNSMmcrSGhN?=
 =?utf-8?B?TEtnbjNBb3E5TVlBWExNL29pb1hTWThZZWpZekN4TVlKUzVvM2hOTTRaNVpU?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bXJuL3VVQ3B4TXFvZ0dQYUhNWkJEZUV1QlZYLzBKTDhRRmt5SVdsQkpyOUVV?=
 =?utf-8?B?RzVkOUNCSFNGdDZUaU9lMU1ZMmVSUXR5c2VkU3YxTHRHVUNZNFhQYmJ6TDhN?=
 =?utf-8?B?NlFML281OEszMnNhSmJDNjVWbkRvSVFha1ZzUXltNFF1WHIxM2F4Tms3MVd1?=
 =?utf-8?B?ZmJRckVTTEFQQzlvMWk3SGtzZXF4MkhmM0Q1T0I5WTBCK29TK2JzMDNOSGhx?=
 =?utf-8?B?NzZZVzRQWVVuQjFPdVhoRDZYdGVjSzIrNFpSb1hNWHRUb20xOWZha0R4Nkp6?=
 =?utf-8?B?ZWcxZkxHaE9NN2QydjAzM1Q1eXN0Tlo2dWtHU2ozblZFZG5oQjJhdE5YRTdp?=
 =?utf-8?B?RGlQcG5ib2lCcnZHOWtRYVB3RDZXQW56dXk1WFdheEg2bE4zSkVpdnVwZDZP?=
 =?utf-8?B?Vkp6cTVMb1NhaTdIWXR2SXpEdjc0TnRxOVl0ZWY3aVdhTnMvUkg0WHZ1eVlZ?=
 =?utf-8?B?VDZyTkpseWNTS0RmU01ZdVV4TWIzR1RaMjl5SWxoUnpDR01McWNBdzc1UFZ4?=
 =?utf-8?B?a0I0NFFDU1QwNVgyU3lsNW81YVJSMFBlQmRMYjNGUGI1RDVPb29wTEZ1M0pt?=
 =?utf-8?B?b0pVVnBHRVgwa3dZSmREWGFDdHBqZDB1NisrclduNkpIN1RQSnVCSU15SU9E?=
 =?utf-8?B?bzduVlcxRkNiWkFuNktDZDZvWDhReDRiN3BiWitYWFZFQncrc2FBUmg2MzZD?=
 =?utf-8?B?dkc0SHJGT2tWM0xyV1IwUWQwR282aXBWWE8zYm5YUmI3MFRWRzByTnA2ZDhv?=
 =?utf-8?B?U0hNWU9XNVFuOXY3TnFsWCt0Y1YxTk5rb3lrcGplZVJhMEdUYVlpdXRSeXZw?=
 =?utf-8?B?N01ZeVZ3d1FUTE1WL1pFcDRvNWRZdzF5cWJoUEJXZy85ZFB6cUF5djRrdk53?=
 =?utf-8?B?djNCY0tNbkhqbFJvNWxOSjBGMUQ0cS9pbGVoRGZWZFFnTDRwdkp0SDdTZGgv?=
 =?utf-8?B?M2NwTnNHSnRWOUV1TVUvZlZ3dS94VllsalV2Z2RlSUN1YkdJbGtVZjVDVERS?=
 =?utf-8?B?TlpiTDNrVEFYYXFSbnVybFNjdHdDVllKdFZ6dFJFMTNqRTlDMDQvWXNnQ3dF?=
 =?utf-8?B?T2J3cFRqcHNHUnJzcFZCYlI0aHBoYUJ1WFM0S1FjZGE2TjBpQmxqZFNBUEFH?=
 =?utf-8?B?cFBkTGtiUHZDaldwWWM5NVB5cnJZVjJoOHE5WGo5cFpwd2oyNGU3cEJWN1J1?=
 =?utf-8?B?eVVLcjc0NTJZQUwwc0tGb2hLZVI3SjhUNFdWQUZXTHZpa29yelF2Q01pT21G?=
 =?utf-8?B?cFZKQjE3S2hMQmJaTGJrc1g4NjhodVFwL0hEVGVFc1pXVEFVdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e49202b-63c4-46bc-d3d2-08db2f7931f4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 10:42:58.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pIGzc77Nd8XO0blBwmyAGxzSBW0pS2zDcXXAoaLtOsf3aB724OODVvkhWCTRHprVy8B+FdDCx1jpjPePdFqq5/QmYmdDqREIIPI5tw120Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6684
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=871 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280088
X-Proofpoint-GUID: IP4o2QY6ZIpqfO7m7aes4KhhAm98Oh9S
X-Proofpoint-ORIG-GUID: IP4o2QY6ZIpqfO7m7aes4KhhAm98Oh9S
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[I was out sick, hence the delay]

On 24/03/2023 14:31, Sean Christopherson wrote:
> On Thu, Mar 16, 2023, Joao Martins wrote:
>> On 16/03/2023 21:01, Sean Christopherson wrote:
>>> Is there any harm in giving deactivate the same treatement?  If the worst case
>>> scenario is a few wasted cycles, having symmetric flows and eliminating benign
>>> bugs seems like a worthwhile tradeoff (assuming this is indeed a relatively slow
>>> path like I think it is).
>>>
>>
>> I wanna say there's no harm, but initially I had such a patch, and on testing it
>> broke the classic interrupt remapping case but I didn't investigate further --
>> my suspicion is that the only case that should care is the updates (not the
>> actual deactivation of guest-mode).
> 
> Ugh, I bet this is due to KVM invoking irq_set_vcpu_affinity() with garbage when
> AVIC is enabled, but KVM can't use a posted interrupt due to the how the IRQ is
> configured.  I vaguely recall a bug report about uninitialized data in "pi" being
> consumed, but I can't find it at the moment.
> 
> 	if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
> 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
> 
> 		...
> 
> 	} else {
> 			/* Use legacy mode in IRTE */
> 			struct amd_iommu_pi_data pi;
> 
> 			/**
> 			 * Here, pi is used to:
> 			 * - Tell IOMMU to use legacy mode for this interrupt.
> 			 * - Retrieve ga_tag of prior interrupt remapping data.
> 			 */
> 			pi.prev_ga_tag = 0;
> 			pi.is_guest_mode = false;
> 			ret = irq_set_vcpu_affinity(host_irq, &pi);
> 	}
> 
> 

I recall one instance of the 'garbage pi data' issue but this was due to
prev_ga_tag not being initialized (see commit f6426ab9c957). As far as I
understand, AMD implementation on irq_vcpu_set_affinity will write back to
caller the following fields of pi:

- prev_ga_tag
- ir_data
- guest_mode (sometimes when it is unsupported or disabled by the host via cmdline)

On legacy interrupt remap path (no iommu avic) the IRQ update just uses irq data
mostly. It's the avic path that uses more things (vcpu_data, ga_tag, base,
ga_root_ptr, ga_vector), but all of which are initialized by KVM properly already.
