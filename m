Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578DF7098F3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjESOGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 10:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjESOGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 10:06:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E740114
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 07:06:32 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCjN8U001593;
        Fri, 19 May 2023 14:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MDtPxjXkjydFgbpTtZMC2C43VHYc7jTysd8fXLTGXJo=;
 b=wmHnx6K8b/0LJR70UFPHS9SW1erJh0Qp6+xWZfAdYOf3zm4s9j/rC6lATPxYvDJU311B
 7RrSZ+Ab9Gb+nRMBq0SqwAOrviMexpnO9yurxGxYHtG1vxQkwp5k7f3ZY0DWEIm8dm2z
 D2JseeFd6nhtUlNqIpLEKK6cjoUWsQ5Ir63QT5Cm+JsAPJu32ZQSUStTlZdRzA/v3kWz
 h0lW1feRRc2/zKkyKDK2J8stvK2URCQ7Idhj4rhM2jEzmgFWkMaYGVjFCSoe5QdfcO7A
 wUROxvS8GOWZ2ATfdPOB1KcgjrrIKnk/hEInakdVRng1dTstyQatArtaOyRzx1kPz33g OQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fcam6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 14:06:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCAkiu004153;
        Fri, 19 May 2023 14:06:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10eej3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 14:06:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMv372J3zVZlaGrydDXsQoScMjBJAMl+sFJlaIT2nCCuk4ImddKdqzGhSTznAq1lkNcepNSJNtgnlm9tuBsCZTUNl67+ovlPkzNjVDilsDqZ6fnCX+ie0Pb5nvhPfOZRGCjVqJI8zWy23OW7wUloDycOS09NkvR5JUQwGAjvDOFV1LCOZ4/8hleNljY3wOC/LPsi0GPvAQK4QkQiCXFvR0Iv2hbnRev9O/+M5FrE8jsdh7jvGeoAIZVX8uneAQX0l3TT05xsgsaFt0FkcmZrSk3kXZEWrT/5xbN4+enDBdWk1Yg1Iud/kWThcW/d3H0OdYa5nP1MbINlEk1wSg75pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDtPxjXkjydFgbpTtZMC2C43VHYc7jTysd8fXLTGXJo=;
 b=R+toPCFHNfXRJ16CPL/hQOTurgMoRP1H+vMqc9WozuFIU89fbGoymRuZum/6YfnvvRROD9HICl1zBCZq1741ROXNn2uq0xqadkBmbM3pht4F5+iHPKpakCK8HFgsuM8cEuD3iETIYReIeKQ6Jk2RoP/Q5Pzlr4DVlHyjsfaVndU3V6HC8Um7EOwxZ1aFiT5z+lz4aqRrELpUjr2R+q4YGn7YSwYCqQ5aQwBybu8iLz6qWtyEVcM8E48H/fuQlNuEIsyVxWoGqYo6qNry/BgMMbb8M8IYxsKRQTar2vBNXVOHr5iM0UKux65tX2HHfyTs6K5IdsKW1AVFtKJXDeS1wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDtPxjXkjydFgbpTtZMC2C43VHYc7jTysd8fXLTGXJo=;
 b=PxsRGXxsx1nrVjGVe1SFpOFtbnXdGipfe185xS+hRHNbmkTWI3bp8xGostFolDInB847uYL1IoYD0y94nvBSxtbTkZdk9aoX+in1ZFzZ24Fw6Yn5RcrACQCU2vHv0zi+WmFhmmdxehuHP3N6gqU4H6lkD3v8RxBsoO88sPewEu4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ2PR10MB7672.namprd10.prod.outlook.com (2603:10b6:a03:53e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 14:06:00 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:06:00 +0000
Message-ID: <907adbcc-de84-3579-dbff-5aaa720d1d5b@oracle.com>
Date:   Fri, 19 May 2023 15:05:52 +0100
Subject: Re: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for stage1
 with io-pgtable mapping
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-22-joao.m.martins@oracle.com>
 <d7aad90c-e009-d577-eb89-3c0859ce3952@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <d7aad90c-e009-d577-eb89-3c0859ce3952@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ2PR10MB7672:EE_
X-MS-Office365-Filtering-Correlation-Id: c38cccb0-9efb-4770-109c-08db58722c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMKI8Kv8rIzS9ar7Bfu+mAhloH9IwvoaLCkD8YhP6iWZ6anvbQguxNcFwUn5bsiCcqzV8HD026dFsmOjbGq4MfjRXhZ/ucyIgOPsEzaoRaObN2Pv61kpTvTFb5CY9HE1DWLpO45AChmd9c2ZI8eEV8Mj4nozSXGZ9b5af4lxm0sUWjUYerzlXebPw+EsLrJRfB2SlKrpinTlhlXCPPRVcb7wzklXdc3PYPrJfwx5QGvnyQUi4R9hELNaQ1LWyX4gy6Hyo6Kg3Z6PJnLKTBH7wwBnXrm8xHIdgIXbXFKEBjhdzsU3IRxNDzj2v+4LOpwC2ObWUXso16UXYIjgBWFMKFzacFR632GfyKttITfnHXL+OLWZSHlbW9iOZ9mmsalteaqxpvBzaRoTYjVYao6vZ/DKZIgqwaHaBaVoXUS13OmPIPr5mf/9DfpdAvSqMd2DHY8fGi5dbviYensJf4B7Mjc1P3QOn4xkAcvW2srE+dEjVyr77pHeXrkYn702BQM6txrBdhzx+MCk8/GHqO133mIS8kRd5kfOFtoKRi8DXL5dcAi0RNba/l2S6sBDy0MuD76wg4kS9pKK0U7vo1Zwr19YCQyhJVIFRZXOXtYZxqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(66556008)(66946007)(4326008)(66476007)(31686004)(54906003)(8936002)(8676002)(478600001)(316002)(6666004)(41300700001)(6486002)(966005)(2906002)(86362001)(31696002)(53546011)(6506007)(6512007)(26005)(38100700002)(83380400001)(2616005)(186003)(7416002)(36756003)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2dNNFpvUk1uOXBFN0ZYckJuaUtkUVJwWVZDTjRjeGw1WGE1L3pQUjBPMTVC?=
 =?utf-8?B?QXVHS29HbVdsMW4wazNjOTFSelphbDQyVWVNUUVaQmxSNTM5VFJiWjdOT0V1?=
 =?utf-8?B?eDB3aUJ0RGpaZVI1ZG5BbmNrUm5OVlJTOTdzR1FraGRYaHNnQk01c1dHUjFH?=
 =?utf-8?B?aEFOWFVHNEpEcm44Wkt5RndoZ0l0L2szOTVBNk80Tk9RZUV6ZFN0YURKakhk?=
 =?utf-8?B?Y3QzMmh3RzYzd05IY2d0M3FTL2d0S0p6WGR5T2NJb1lJVGREaUI0Zm0wMVNC?=
 =?utf-8?B?MlJjeVJQTGpjMlBUTHdSTm03eHA0Z2RyNmdHUDd0UVVoRVZSbGVwY1M5dDMz?=
 =?utf-8?B?YkFaZWpCMnNENm9VYnVLemtpMlZocDgvRFA3eXY2N1M0bi8vN2lISUIraDI4?=
 =?utf-8?B?QTNUdm53Q2F1c0RaTXZLbytBVlB0Wjk4clFGdit2dFNGZnRZQTFKWU1tTFli?=
 =?utf-8?B?YndHK3I3RmtUUFdpbDgxQjdhMFRyOXhYWmtHVEc4VXBUY2d3N3NhTERpbDVs?=
 =?utf-8?B?djIxaldOVUFtNXp2NXJVTGpyRFRZZGRjVytGZis3RUpUSlhkTXdKL2NmVXMw?=
 =?utf-8?B?UjkzcktHZXN4OXF2bkRuaEZoazhaZ0VUMVEzSGdYc3dhSlNpdHZacG1zbGM1?=
 =?utf-8?B?RDBRTGhJcW1rYUJFQ2RFUlRCeGdmR2YxajIyQVB5alRlbWlXeExzTmNTMDNR?=
 =?utf-8?B?UzdvbnFWNDd6Q0ZMVjFsVnpKdWs2bjNaSDlsWHZjWUlaU2dwRldBck5TblJT?=
 =?utf-8?B?dmZNaVFXOStwZThjV0FyNlpSVHkwQk5CZkJyN1VkZ0RvTUxNKytaNUw4TUJq?=
 =?utf-8?B?SDFWenVsWEY4dFdJcndFWHd3eXhwcEt3NFJNdytTandlS2tqZnVTejZiQlpZ?=
 =?utf-8?B?aEo2OXg3QzhEeERFUUpMcjdDWkRUcS9QdW1WaVpQdlZkZFQzMzFxWncyeFZW?=
 =?utf-8?B?bXhmZmRKY1ZlY1BuOE1NL3hEVElheVdzU1NqckFGOGVwaWwra05PbHVjWjBn?=
 =?utf-8?B?SVAvTWRvbHlyeUVEZ0ZORG00aWtrNFRsQkE1NGNBd2ZOVHVCQ2d0UTA0azls?=
 =?utf-8?B?Rk5NaXpYd0tPRHNaYU8rRllWcWMvM09SMXVEMlZ3SmxlMmZqTitxUlBhd2la?=
 =?utf-8?B?L3hBeFRqQ1hPTFEzOVZpM05CZGwxUVB3TXdscjJJaFVnSkErTDhxNnFTZ0lX?=
 =?utf-8?B?L1ZnZ1creFZNOC9qczN4Tk5ncUFDdWdLK3BCKzBMaWNOelYrSkFlNHJubll6?=
 =?utf-8?B?d3l0SmRyc1RjZEZXaHArbld0RkRwWFNuUEVQek9FR1lGZmxHczUxMzZBTXZq?=
 =?utf-8?B?QXE5c2dSWkhZak5Fd3pwRUxVL2xKSmszTmg4dkF6UWNjZ1hiUnNHWmhDblhR?=
 =?utf-8?B?VVBNNWl6VDU2Nmk2eVdZZmxpMk91UzZ0Z3lUdUU1TmhGUE83M1NHWXZWSEZj?=
 =?utf-8?B?NE1jbDVpSms0aW9LZVcyeVpTMU44cEpHSXcrNTRnNGc1NHBIT28xTlhhYjlZ?=
 =?utf-8?B?azhMNnpBTTY0b0lWQXB1MkJMblgzUWY4MUhzbWlPWEJ4ZVhPd0Q4NG1FNHpl?=
 =?utf-8?B?L0liTktNdlQ5d3drc095R250WXFCYmNYbUM3VXFwdE5Vc0pWVXg2L2xac3BR?=
 =?utf-8?B?QmN2blFrd1ZxallCNXBEak41VVlhS1lhWmdzWHlaSTdXR1d4eFN4bGxlUGQv?=
 =?utf-8?B?cG56bUkyWlJsd0tGRWkzVVAwLyt4WnA2ejRuakNNdU44ME9nOFZkVHlOK2Zx?=
 =?utf-8?B?RVpYbTJqOGFNSlR6MnNMSnp4VnlNbHNUenNFdlFJUGptRjlmdmoxRjdpYloy?=
 =?utf-8?B?WXpnTHBsbVJUemxUUjBzbmF5TjRFc2NKQWVUcThuOXVOVXRacGszTlVici84?=
 =?utf-8?B?OHBaVHo5RExiSjAzQkR5ekhyWmNGdVlUR0VmMWFpTXhlbzE1Y1d4SmlPbUlM?=
 =?utf-8?B?QnNkbGdDY3FTT3VJSUdCNld2WFpaSC9DaHRWd2ZyN3BCd2E3dlVhd0N2WmNv?=
 =?utf-8?B?S24vZGR6UVFtck5vUnNTMEJhRmUxME14eXY3UGtEK0NJdTROdjJFQngwbUtu?=
 =?utf-8?B?R0R3dFdva1F1MEFTRG0vVG55dWJsNncwODJJdnFJU3JHTWRteGNmTFJ2NWxv?=
 =?utf-8?B?a1pLRFBZcDMyemJsRWZMUzByeVNUcEsycWdJam5ITDNZZm5nZnQrMkNEa00z?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bkx3bTZrbkZ0YjhFelBkVHpJaEl0anRUdUhFcDNDRDJUNG1GN3QzMGZoNVdz?=
 =?utf-8?B?eTcyUkVTc3NqVXkwR1VPY1kzR0kxR1hwTWtQSkpIeFFFK1FFMFN0ekdoT0xn?=
 =?utf-8?B?Ky9EZjdRa0lUWVNoZzBaRW5WTUhhR2lSZmtoMXRwN1NUQ2NySE9DQnY4YUg3?=
 =?utf-8?B?Z2NtQkx1cHE4VDlUY3RUdVZKV25EczVVZlFuQndCcFU0TkE2bSs2SCs4Snlp?=
 =?utf-8?B?L3VYOU1iMG1Eem9HY1Q5UjhEY2tmekJ5WlJKMmpiRjdZYTNkNjFMUk9KdlVj?=
 =?utf-8?B?TUNqR1p1NkZOMlVhZ0M2UTFYdnRqcXlSZis5Z2dyekU5R3RqYllxYzAzSEJz?=
 =?utf-8?B?SS85N29KMWNFNjNyRkpsUUErM0k2ZWFLVjRId3pIRlpvbFpXTWRUNFBkQ0Nn?=
 =?utf-8?B?Z0JXcXY2T08zYXRFNS9rdFh5anR6U2UxSzF1Ky9wZUk1WDlPb2NpQXJ3QVgv?=
 =?utf-8?B?VDFIMzEvc251dU1hcEpFdzJMbHh5cTM4aUdneGJaRmJHNERjZG1kR0RJSjRI?=
 =?utf-8?B?SU5RYzF4bXY5Q1RNYkJTZHdjK0Rzd1l4UHhxbThHQTdPRmZvZkhWbzV4eHNk?=
 =?utf-8?B?dUlsS1p6UUJ1MHhsVFUvN25YbkVRaUIwWGE4ZlUwNHN1dGtGQjAwODg5alkw?=
 =?utf-8?B?VWNzTGFJRys3MVlXTTdjM0haTVErZHBacXNGVE1IcDVBN1JaNklpMytPTUhF?=
 =?utf-8?B?TTVPZWxBekZKYlhQcjNqdW9sK3lQU1l4QzJxeFlxNGtwOVNiODhXM2tSNWhv?=
 =?utf-8?B?YUp2bVMwcTdpV0x3b1BZbHNqMklZV1UvVnhmUFMydk5Mck85UzdEdnEyMm03?=
 =?utf-8?B?NEJRUG8rU0dlalJhQTZNcUNoTm14OXN5U0FVWk9wamZORUFWci9rUnorbkl1?=
 =?utf-8?B?U1NHaW1HWGxFZFJJMVlySmZYU2srZ0hLekdEOVh2L2pTTlpNaW5sdFVod0pq?=
 =?utf-8?B?Q04xeEtURmxTVFJ5aUhqeG5kNGxCeGdqY24zdk5JNHI3RzFJdDhkNXVVRExZ?=
 =?utf-8?B?cldHRG8zajVrc0NjMEFWb3BXUzM3azk3TWcxRU9TWW00blpETHc5UWtxYTkv?=
 =?utf-8?B?UVBndDhkK1Q5dW80VTZ4cUtqU3Y5YnFYRU13eXhZWkhTUFhON0pvc2hGdExS?=
 =?utf-8?B?eUp1YXFmVDVSZUd0TjFpZ0tKckZSeUhWc29LSlI4RmNodldTWUlQYThUMjNJ?=
 =?utf-8?B?OG8rdGU4TVN1N3Uwc1czSks4OC9lMFU2SFl6TDB2SG54SndGYkdJWmtIZE5o?=
 =?utf-8?B?TnhBVi9DUlZoT1pkVHRqWmRlVTdZRzlKWkM0cm1PVmtpbG1BWTR1MWpsQWgv?=
 =?utf-8?B?S3hwYllUTDVYTm0wRUVRSVRLbHdBZlRmY2tWNnNPcHdybllFRzFaemk4SHpL?=
 =?utf-8?B?V3AxeTRNUVdtUFZzcUZPRXJFeFdES3AxZnVabEU4bml6bzh3MHNVcGZhSmNy?=
 =?utf-8?B?eEY2Mm54ZFNMVkI2dmEzTWlCUCtCOXljUlNCOHNBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38cccb0-9efb-4770-109c-08db58722c6e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 14:06:00.0472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZw919iLEzmFgxUqwh+bvh4fr+OXPs6kK/kXizgvF4KW4A8/6iIVtvQfrxK9LjNlOKbdvE25tF+qODWW/svm6L22TM07bEf/zcgJ2FL72m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190119
X-Proofpoint-ORIG-GUID: fUUaq7eekTri8m2SiMs9V3T-UFq-iQjE
X-Proofpoint-GUID: fUUaq7eekTri8m2SiMs9V3T-UFq-iQjE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:49, Robin Murphy wrote:
> On 2023-05-18 21:46, Joao Martins wrote:
>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>
>> As nested mode is not upstreamed now, we just aim to support dirty
>> log tracking for stage1 with io-pgtable mapping (means not support
>> SVA mapping). If HTTU is supported, we enable HA/HD bits in the SMMU
>> CD and transfer ARM_HD quirk to io-pgtable.
>>
>> We additionally filter out HD|HA if not supportted. The CD.HD bit
>> is not particularly useful unless we toggle the DBM bit in the PTE
>> entries.
> 
> ...seeds odd to describe the control which fundamentally enables DBM or not as
> "not particularly useful" to the DBM use-case :/
> 

This is a remnant from v1 where we would just enable the context descriptor HD
bit, but not actually enabling DBM until set_dirty_Tracking(). Which no longer
is the case. Should remove this sentence.

>> Link: https://lore.kernel.org/lkml/20210413085457.25400-6-zhukeqian1@huawei.com/
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> [joaomart:Convey HD|HA bits over to the context descriptor
>>   and update commit message; original in Link, where this is based on]
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++++
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>>   drivers/iommu/io-pgtable-arm.c              | 11 +++++++++--
>>   include/linux/io-pgtable.h                  |  4 ++++
> 
> For the sake of cleanliness, please split the io-pgtable and SMMU additions into
> separate patches (you could perhaps then squash set_dirty_tracking() into the
> SMMU patch as well).
> 
ack
