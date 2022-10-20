Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E756057BB
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 08:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJTG4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 02:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJTG4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 02:56:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E65A120EF9
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 23:56:35 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K6bsbo011968
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QplY6tD2v4iEKcz+U1eStzYBsGa7iKnVwYTF/Df5Uek=;
 b=bKGXnmE7/b7jvFzQygynzsiCJBLiraeRzTGiahigDYIznBreVyHb3Ycc344yvBgX9WkS
 Fg70HAGTFNEKC6WHdzH4izK5YpZlaUNkiti0DZuzVWU5x2568qPUodZ38sAMBc5mpxV7
 PgwKceUG1al+VONq35sLGOaNPt2NGx7Y3xDySZjoIGxiBL6g8h93BTTKShPzU3KweZYG
 gg62FAtDJgWnoSg85uLK3NSkOqFTxtexH+lCr/nq7A0nRjBCO/lg5/j5znE0UU+vmz9b
 ylEOAxOcP1fNgguKhmwkwohkyqvEODCS5KPoYBWP+mDmC+NfDJmjEOWGAUDpTUE4siAd ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb0yh0rnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:56:34 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K6dc24018278
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:56:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb0yh0rmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 06:56:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K6q4bt018494;
        Thu, 20 Oct 2022 06:56:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg98bb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 06:56:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K6uSEB66257230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 06:56:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9077442041;
        Thu, 20 Oct 2022 06:56:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15A454203F;
        Thu, 20 Oct 2022 06:56:28 +0000 (GMT)
Received: from [9.171.57.143] (unknown [9.171.57.143])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 06:56:28 +0000 (GMT)
Message-ID: <a4909c99-1aa6-1acb-5ff6-1093a1b1dadf@linux.ibm.com>
Date:   Thu, 20 Oct 2022 08:56:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: do not enable PV dump
 support by default
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
 <20221019145320.1228710-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221019145320.1228710-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -WYLf3cqlnDs1Y6CYjIA7AGo9uBMs2sW
X-Proofpoint-ORIG-GUID: VDkeFOKOkBqFqIUnIQ0GkjaEvW6ZG-v-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_01,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 16:53, Nico Boehr wrote:
> Currently, dump support is always enabled by setting the respective
> plaintext control flag (PCF). Unfortunately, older machines without
> support for PV dump will not start the guest when this PCF is set. This
> will result in an error message like this:
> 
> qemu-system-s390x: KVM PV command 2 (KVM_PV_SET_SEC_PARMS) failed: header rc 106 rrc 0 IOCTL rc: -22
> 
> Hence, by default, disable dump support to preserve compatibility with
> older machines. Users can enable dumping support by passing
> --enable-dump to the configure script.
> 

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

