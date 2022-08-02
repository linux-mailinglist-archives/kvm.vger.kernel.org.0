Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4835877B1
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbiHBHRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiHBHRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:17:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C991D4A803
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:17:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2726vnjV011698
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=nyphGySCV5i/7pysa+sPC0VJzQoHynmHRKFagFDJQqM=;
 b=PBAL0FlRH4Yv2DoBhbrgIFkMBsK4vVFT52eW2DXaM9gdfgLzTa1j6dlUlozh2F/MbGLS
 wOHpgiHYNTEuSsmWUYgQlcXxpU5Xnnh/CvsCZpSHc9hx+nBBL2vjTAza6SnFEk6hVOqL
 7TcsG3EQkVZMJ+//M4WfqXWH/QWDUWAuOtUG9AXPrQJ/AzU2wG8tEVVulefILTBo9tKG
 mOFyuYbrLv/IerBTc5LnrpShxgRtUKNbxYS/lkLDzAXHc+PRv1ZFJKuowS9bY2TgJBzA
 vXwM6S/FmosgLHPo+HnTqaYfJvmM6/x5wYFhNu1NbAKGV3pvi3Nb2Tq5GNbI7RZBiSLU BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpy4arj7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:17:31 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2726xJ6a017924
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:17:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpy4arj73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:17:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27275ZwK003017;
        Tue, 2 Aug 2022 07:17:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3hmv98jedh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:17:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727FCgT24904018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:15:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5765852050;
        Tue,  2 Aug 2022 07:17:25 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3C95C5204F;
        Tue,  2 Aug 2022 07:17:25 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-4-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-4-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] s390x: Add a linker script to assembly snippets
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <165942464507.253051.15803807625662546152@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 09:17:25 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DwBbTORON0MCXkA1GjDlF0AXI27xuhAF
X-Proofpoint-GUID: zBHgQqOKttF1JELMa1COuYkY9C3v1dMg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:30)
[...]
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 9ced68c7..5165937a 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -28,7 +28,7 @@ static void test_diag_500(void)
> =20
>         snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
>                         SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> -                       size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +                       size_gbin, size_hdr, SNIPPET_UNPACK_OFF);

Does it even make sense to pass SNIPPET_UNPACK_OFF? Since this is now the s=
ame for C and ASM we could completely get rid of this argument, couldn't we?
