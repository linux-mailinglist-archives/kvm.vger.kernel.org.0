Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783976C4964
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCVLnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCVLnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:43:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B722E1A664
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:43:08 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MBCJBL013427;
        Wed, 22 Mar 2023 11:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : from : cc : message-id : date; s=pp1;
 bh=m3sxHcTzOlOFW+4zvzth03e3+6eZ2rsq7XR8If/tu1M=;
 b=WYpz+DEaGj2K4IHJA/LgOTptnCuC3VWwoXjX6PsUMn4X9zbyQinb9DM+Z9DRNAxTQcwi
 hApdFhIhN0COpW7dqRIqbl8w96c9pPa8YgbWlfWA92S+4EFycpV2r7zKik9ldfQs9bN0
 eLV/lwNA88lEWXu2yDnpecULXyPhW8eYNXfhYGG5qA2JqbprvY02a9H8/V7YJNUJqySR
 z9WvEmEw3jJKuBP9Ycsm9bq0Eqbp4a877PQ8iarKYqYQZ03DZ0eusasnxERQ89YQG7rf
 CPU5Wt0IW9l5yv9hzqZd3M+wrLs5uo2py4juIX97z8BHsQNefoHsKGZgWp6s2C04I6iy +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0khgq8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:43:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MBTM2j021072;
        Wed, 22 Mar 2023 11:43:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0khgq7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:43:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32M1G0bo023982;
        Wed, 22 Mar 2023 11:43:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6dv1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:43:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MBgw9s21037694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 11:42:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A81F22004E;
        Wed, 22 Mar 2023 11:42:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9253720040;
        Wed, 22 Mar 2023 11:42:58 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.93])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 11:42:58 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230322113400.1123378-1-frankja@linux.ibm.com>
References: <20230322113400.1123378-1-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add Nico as s390x Maintainer and make Thomas reviewer
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     pbonzini@redhat.com, andrew.jones@linux.dev,
        imbrenda@linux.ibm.com, david@redhat.com, borntraeger@linux.ibm.com
Message-ID: <167948537840.37246.654906510480595119@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 22 Mar 2023 12:42:58 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sTKO-yT-m8VJQ8HKXaXQIHFxL36EI2Gi
X-Proofpoint-ORIG-GUID: HVPH8lUmKfnnp-V2h5pIKNAigTa-sdD-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_08,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 mlxlogscore=945 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303220082
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-22 12:34:00)
> The circle of life continues as we bring in Nico as a s390x
> maintainer. Thomas moves from the maintainer position to reviewer but
> he's a general maintainer of the project anyway.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Acked-by: Nico Boehr <nrb@linux.ibm.com>

Thank you!
